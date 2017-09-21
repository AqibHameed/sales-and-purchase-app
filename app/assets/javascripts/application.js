// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_nested_form
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require fancybox
//= require jquery.dataTables.min.js
//= require jquery.raty.js
//= require jquery.tablesorter.min.js
//= require highcharts
//= require jquery.fancybox-1.3.4
//= require moment
//= require bootstrap-datetimepicker
//= require jquery-countdown
//= require select2


//Admin Login
$(document).ready(function() {
  $('.tender-house4').on('click',function () {
    $(".tender-house4").is(':checked') ? $('.tender-house3').attr('disabled', true).prop('checked', false) : $('.tender-house3').prop('checked', false).attr('disabled', false)   
  })
  $(".footer-inner .c6").click(function() {
    $('#sidebar-share').fadeOut();
    $('#sidebar-features').slideToggle(500);
  });

  $(".footer-inner .c5").click(function() {
    $('#sidebar-features').fadeOut();
    $('#sidebar-share').slideToggle(500);
  });

  //$("#myTable").tablesorter();
  $(document).on('change', '#transaction', function(){
    val = $(this).val()
    if(val == "Pending Transactions"){
      $('.pending').removeClass('hide')
      $('.overdue').addClass('hide')
      $('.complete').addClass('hide')
      $('.rejected').addClass('hide')
    }else if(val == "Overdue Transactions"){
      $('.pending').addClass('hide')
      $('.overdue').removeClass('hide')
      $('.complete').addClass('hide')
      $('.rejected').addClass('hide')
    }else if (val == "Complete Transactions"){
      $('.pending').addClass('hide')
      $('.overdue').addClass('hide')
      $('.complete').removeClass('hide')
      $('.rejected').addClass('hide')
    }else if (val == "Rejected Transactions"){
      $('.pending').addClass('hide')
      $('.overdue').addClass('hide')
      $('.complete').addClass('hide')
      $('.rejected').removeClass('hide')
    }else{
      $('.pending').addClass('hide')
      $('.overdue').addClass('hide')
      $('.complete').addClass('hide')
      $('.rejected').addClass('hide')
    }
  })

  $('#creditList').DataTable({
    // "paging": false,
    "pageLength": 20,
    "bLengthChange": false,
    "searching": false,
    "bInfo" : false,
  });

  // $(document).click(function(e){
  //   if (!e.target.matches('.dropbtn')) {
  //     var dropdowns = $(".dropdown-content");
  //     var i;
  //     for (i = 0; i < dropdowns.length; i++) {
  //       var openDropdown = dropdowns[i];
  //       if (dropdowns.hasClass('show')) {
  //         dropdowns.removeClass('show');
  //       }
  //     }
  //   }
  // })

  $('.dropdown').hover(function() {
    $(this).parent().find('#myDropdown').stop(true, true).delay(200).fadeIn(500);
  }, function() {
    $(this).parent().find('#myDropdown').stop(true, true).delay(200).fadeOut(500);
  });
});

// function myFunction() {
//   $("#myDropdown").toggleClass("show");
// }

function addMask() {
  $('body').append("<div id='screenMask'></div>")
}

function removeMask() {
  $('#screenMask').remove();
}

function addStarRatings(id) {
  $('.star').each(function(i) {

    $(this).raty({
      path : '/assets',
      width : 10,
      number : 1,
      hints : ['Important'],
      score : $(this).attr('score'),
      round : {
        down : .25,
        full : .6,
        up : .76
      },
      click : function(score) {
        $.post("/tenders/" + id + "/add_rating", {
          key : $(this).attr('key'),
          id_key : $(this).attr('id_key'),
          value : score
        });
      }
    });
  });
}

function addRead(id) {

  $('.read').each(function(el) {
    var el = el;
    $(this).click(function() {
      $.post("/tenders/" + id + "/add_read", {
        key : $(this).attr('key'),
        id_key : $(this).attr('id')
      });
    });
  });
}

function reloadRaty(id, status) {

  var src = $("#star_" + id).find('img').attr('src');

  if (status == "on") {
    var imageSource = src.replace('off', 'on');
    $("#star_" + id).next().html('1');

  } else {
    var imageSource = src.replace('on', 'off');
    $("#star_" + id).next().html('0');
    $('#star_' + id).raty({
      path : '/assets',
      width : 1,
      number : 1,
      hints : ['Important'],
      score : 0,
      round : {
        down : .25,
        full : .6,
        up : .76
      },
      click : function(score) {
        $.post("/tenders/" + id + "/add_rating", {
          key : $(this).attr('key'),
          id_key : $(this).attr('id_key'),
          value : score
        });
      }
    });

  }

  $("#star_" + id).find('img').attr('src', imageSource);
  $("#myTable").trigger("update");

}

function isNumber(evt) {
  evt = (evt) ? evt : window.event;
  var charCode = (evt.which) ? evt.which : evt.keyCode;

  if (charCode == 46) {
    return true;
  } else if (charCode > 31 && (charCode < 48 || charCode > 57)) {
    return false;
  }
  return true;
}
