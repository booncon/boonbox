var loadIntval = giphys = "";  // global variable to store interval
var errors = ['Please enter a valid github repository.', 'Please enter a valid project name.']; // error messages

// Returns an the markup for an alert of the given type
var showAlert = function (type, message) {
  var html = '<div id="addProjectAlert" class="alert alert-' + type + ' alert-dismissible" role="alert">';
    html += '<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>';
    html += '<span class="message">' + message + '</span></div>';
  return html;
};

// Loads a gif through giphys api into an img
var loadGiphy = function () {
  if (giphys === "") {
    var xhr = $.get("http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=100");
    xhr.done(function (data) {
      giphys = data;
      $('#giphy-wrap').removeClass('hide');
      $('#db-info').hide();
      refreshGiphy();
    });
  } else {
    refreshGiphy();
  }
};

var refreshGiphy = function () {
  $('#giphy').attr('src', giphys['data'][Math.round(Math.random() * 100)]['images']['fixed_height_downsampled']['url']);
};

// start showing gifs
var showGifs = function () {
  $('#githubInput, #projectName').prop('readonly', true);
  $('#closeModalBtn').prop('disabled', true);
  loadGiphy();
  if (loadIntval === "") {
    loadIntval = window.setInterval("loadGiphy()", 8000);
  }
};

// stop showing gifs
var stopGifs = function () {
  window.clearInterval(loadIntval);
  loadIntval = "";
  $('#githubInput, #projectName').prop('readonly', false);
  $('#closeModalBtn').prop('disabled', false);
  $('#db-info').show();
  $('#giphy-wrap').addClass('hide');
  giphys = "";
};

var reloadProjects = function (alert, projectName) {
  $('#main-content-wrapper').load('index.php #main-content', function () {
    $('#addModal').modal('hide');
    stopGifs();
    $('#successAlertWrapper').html(alert);
    if (projectName !== undefined) {
      $('.site-item.' + projectName).addClass('new');
    }
    window.setTimeout(function () {
      $('#successAlertWrapper').html('');
      $('.site-item').removeClass('new');
    }, 10000);
  });
};

$(document).ready(function () {
  // click on brand refreshes projects -> ajax
  $('#brand').click(function (e) {
    reloadProjects();
    e.preventDefault();
  });

  // reset form when switching tabs or opening modal
  $( "body" ).on( "click", ".site-link.add-new, .nav-tabs a", function () {
    $('#addProjectFormAlertWrap, #successAlertWrapper').html('');
    $('#githubInput, #projectName').val('');
  });

  // trigger dropdown actions
  $("body").on( "click", ".actionBtn", function (e) {          
    var projectName = $(this).data('project');
    var displayName = $('.site-link.' + projectName).text();
    if ($(this).hasClass('removeBtn')) {
      var message = "Attention: This will remove all your local project files and wipe the database and user. Do you really want to delete this project? ";
      var x = confirm(message);
      if (x === true) {
        $('.site-link.' + projectName).html('<i class="throbber"></i>').parent().addClass('loading').children().children('.dropdown-toggle').addClass('disabled');
        $.ajax({
          type: "GET",
          url: "action.php",
          data: { remove: projectName }
        }).success(function (response) {
          console.log(response);
          reloadProjects(showAlert('success', '<strong>Success!</strong> You removed the project "' + projectName + '".'), projectName);
        }).error(function (response) {
          console.log(response);
          reloadProjects(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
        });
      }
    } else if ($(this).hasClass('pullBtn')) {
      var message = "Attention: This will overwrite your existing database. Are you sure about that?";
      var x = confirm(message);
      if (x === true) {
        $('.site-link.' + projectName).html('<i class="throbber"></i>').parent().addClass('loading').children().children('.dropdown-toggle').addClass('disabled');
        $.ajax({
          type: "GET",
          url: "action.php",
          data: { pull: projectName }
        }).success(function (response) {
          console.log(response);
          reloadProjects(showAlert('success', '<strong>Success!</strong> Your project "' + projectName + '" is now in sync with staging.'), projectName);
        }).error(function (response) {
          console.log(response);
          reloadProjects(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
        });
      }
    } else if ($(this).hasClass('pushBtn')) {
      var message = "Please make sure that the git repository has been set up and that the project does not exist on staging!";
      var x = confirm(message);
      if (x === true) {
        $('.site-link.' + projectName).html('<i class="throbber"></i>').parent().addClass('loading').children().children('.dropdown-toggle').addClass('disabled');
        $.ajax({
          type: "GET",
          url: "action.php",
          data: { push: projectName }
        }).success(function (response) {
          console.log(response);
          reloadProjects(showAlert('success', '<strong>Success!</strong> Your project "' + projectName + '" has been set up on staging.'), projectName);
        }).error(function (response) {
          console.log(response);
          reloadProjects(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
        });
      }
    }
    e.preventDefault();
  });

  // add an existing project
  $( "#addProjectForm" ).submit(function (event) {
    $('#addProjectFormAlertWrap').html('');
    var githubURL = $('#githubInput').val();
    if (githubURL !== '' && githubURL.indexOf('/') !== -1) {
      showGifs();
      var projectName = githubURL.split('/');
      projectName = projectName[projectName.length - 1].split('.')[0]
      var $btn = $("#addProject").button('loading');
      $.ajax({
        type: "GET",
        url: "action.php",
        data: { add: $('#githubInput').val(), pull: projectName }
      }).success(function (response) {
        console.log(response);
        reloadProjects(showAlert('success', '<strong>Success!</strong> You have added the project "' + projectName + '".'), projectName);
        $btn.button('reset');             
      }).error(function (response) {
        console.log(response);
        $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
        $btn.button('reset');
        stopGifs();
      });
    } else {
      $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + errors[0]));
      stopGifs();
    }
    event.preventDefault();
  });

  // create a new project
  $( "#createProjectForm" ).submit(function (event) {
    $('#addProjectFormAlertWrap').html('');
    var projectName = $('#projectName').val();
    if (/^[A-Za-z]+[A-Za-z-]+[A-Za-z]+$/.test(projectName)) {
      showGifs();
      var $btn = $("#createProject").button('loading');
      $.ajax({
        type: "GET",
        url: "action.php",
        data: { create: $('#projectName').val() }
      }).success(function (response) {
        console.log(response);
        reloadProjects(showAlert('success', '<strong>Success!</strong> You have created the project "' + projectName + '".'), projectName);
        $btn.button('reset');
      }).error(function (response) {
        console.log(response);
        $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
        $btn.button('reset');
        stopGifs();
      });
    } else {
      $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + errors[1]));
      stopGifs();
    }
    event.preventDefault();
  });
});