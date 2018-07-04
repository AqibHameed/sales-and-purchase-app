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
//= require bootstrap-sprockets
//= require dataTables/jquery.dataTables
//= require fancybox
//= require jquery.dataTables.min.js
//= require jquery.raty.js
//= require jquery.tablesorter.min.js
//= require turbolinks
//= require highcharts
//= require jquery.fancybox-1.3.4
//= require moment
//= require bootstrap-datetimepicker
//= require jquery-countdown
// = require FlipClock/compiled/flipclock.min
// = require FlipClock/compiled/flipclock
//= require select2
//= require jquery.ui.monthpicker
//= require intlTelInput
//= require libphonenumber/utils


//Admin Login
$(document).ready(function() {
  $("#mobile_no").intlTelInput({
    formatOnInit: true,
    separateDialCode: true,
    autoHideDialCode: false
  });

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

  $(".refresh").click(function() {
    window.location.reload()
  });

  $('.select2').select2({
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

  // $('#creditList').DataTable({
  //   // "paging": false,
  //   "pageLength": 20,
  //   // "bLengthChange": false,
  //   "bInfo" : false
  //   // "columnDefs": [
  //   //   { "orderable": false, "targets": 0 },
  //   //   { "orderable": false, "targets": 1 },
  //   //   { "orderable": false, "targets": 2 },
  //   //   { "orderable": false, "targets": 3 },
  //   //   { "orderable": false, "targets": 4 },
  //   //   { "orderable": false, "targets": 5 },
  //   //   { "orderable": false, "targets": 6 }
  //   // ]
  // });



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

$(document).on('click', '.signup-btn', function(){
  $("#customer_mobile_no").val($("#mobile_no").intlTelInput("getNumber"))
});

$(document).on('click', '.login-btn', function(){
  $("#customer_mobile_no").val($("#mobile_no").intlTelInput("getNumber"))
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

$(document).ready(function() {
  $(document).on('click', '.sale_visibility', function(){
    id = $(this).data('id')
    $.ajax({
      url : '/parcel_detail',
      data : { id: id }
    });
  })

  $(document).on('change', '#sale_all', function() {
    if ($(this).is(':checked')) {
      $('#sale_broker').attr('disabled', true)
      $('#sale_none').attr('disabled', true)
      $('#sale_credit').attr('disabled', true)
      $('#sale_demanded').attr('disabled', true)
      $('.broker-list').addClass('hide')
    } else {
      $('#sale_broker').attr('disabled', false)
      $('#sale_none').attr('disabled', false)
      $('#sale_credit').attr('disabled', false)
      $('#sale_demanded').attr('disabled', false)
    }
  })

  $(document).on('change', '#sale_none', function() {
    if ($(this).is(':checked')) {
      $('#sale_broker').attr('disabled', true)
      $('#sale_all').attr('disabled', true)
      $('#sale_credit').attr('disabled', true)
      $('#sale_demanded').attr('disabled', true)
      $('.broker-list').addClass('hide')
    } else {
      $('#sale_broker').attr('disabled', false)
      $('#sale_all').attr('disabled', false)
      $('#sale_credit').attr('disabled', false)
      $('#sale_demanded').attr('disabled', false)
    }
  })

  $(document).on('change', '#sale_broker', function() {
    if ($(this).is(':checked')) {
      $('#sale_none').attr('disabled', true)
      $('#sale_all').attr('disabled', true)
      $('#sale_credit').attr('disabled', true)
      $('#sale_demanded').attr('disabled', true)
      $('.broker-list').removeClass('hide')
    } else {
      $('#sale_none').attr('disabled', false)
      $('#sale_all').attr('disabled', false)
      $('#sale_credit').attr('disabled', false)
      $('#sale_demanded').attr('disabled', false)
      $('.broker-list').addClass('hide')
    }
  })

  $(document).on('change', '#sale_demanded', function() {
    if ($(this).is(':checked')) {
      $('#sale_none').attr('disabled', true)
      $('#sale_all').attr('disabled', true)
      $('#sale_broker').attr('disabled', true)
      $('#sale_credit').attr('disabled', false)
      $('.broker-list').addClass('hide')
    } else {
      $('#sale_none').attr('disabled', false)
      $('#sale_all').attr('disabled', false)
      $('#sale_credit').attr('disabled', false)
      $('#sale_broker').attr('disabled', false)
    }
  })

  $(document).on('change', '#sale_credit', function() {
    if ($(this).is(':checked')) {
      $('#sale_none').attr('disabled', true)
      $('#sale_all').attr('disabled', true)
      $('#sale_broker').attr('disabled', true)
      $('#sale_demanded').attr('disabled', false)
      $('.broker-list').addClass('hide')
    } else {
      $('#sale_none').attr('disabled', false)
      $('#sale_all').attr('disabled', false)
      $('#sale_broker').attr('disabled', false)
      $('#sale_demanded').attr('disabled', false)
    }
  })
    
  $(document).on('change', '.for_sale', function() {
    var column = $(this).val()
    var parcel_id = $(this).data('id');
    if ($(this).is(':checked')) {
      var val = true
    } else {
      var val = false
    }
    $.ajax({
      url: '/customers/'+parcel_id+'/check_for_sale',
      data: { val: val, col: column },
      type: "GET"
    })
    
    // if(val == "2"){
    //   $(this).parent('td').find('.broker-list').removeClass('hide')
    // }else{
    //   $(this).parent('td').find('.broker-list').addClass('hide')
    // }
    // parcel_id = $(this).data('id');
    // val = $(this).val()
  })

  $('.broker-select').select2({})

  $('.broker-select').on("change", function (e) {
    broker_ids = $(this).val();
    parcel_id = $(this).data('id')
    $.ajax({
      url : '/share_with_brokers',
      data : { broker_ids: broker_ids, id: parcel_id }
    });
  })
});

$(document).ready(function() {

  // Responsive tables data show
  $(document).on('click', '.table-responsive .td-mobile-count', function(){
    $(this).closest('tr').toggleClass('opened');
  });

  $(document).on('click', '.table-responsive .table-head-in-td', function(){
    $(this).closest('tr').toggleClass('opened');
  });


  // Mobile menu
  if($('.menu-burger').length){
    $('.menu-burger').click(function(){
      $(this).toggleClass('opened');
      $('.header .c1 .nav').toggleClass('opened');
    });
  }

  $('#demand_description').select2({

  });
});


function ajaxRequest(url, data, callback, errorCallback, type) {
  if(typeof type == 'undefined') {
    type = 'GET'
  }
  if (typeof errorCallback == 'undefined') {
    errorCallback = false
  }
  if (!data) {
    data = {};
  }
  $.ajax({
    url : url,
    type : type,
    data : data,
    success: function (data) {
      if(typeof callback == 'function') {
        callback(data);
      }
    },
    error: function (jqXHR, textStatus,errorThrown) {
      console.log(jqXHR, textStatus, errorThrown);
      if(errorCallback !== false && typeof callback == 'function') {
          errorCallback(jqXHR, textStatus,errorThrown);
      } else {
          alert('An error occurred: ' + textStatus + ' ' + errorThrown);
      }
    }
  });

}


$(document).on('click', '.size_info', function(){
  id = $(this).data('id')
  $.ajax({
    url : '/trading_parcels/'+id+'/size_info',
  });
})