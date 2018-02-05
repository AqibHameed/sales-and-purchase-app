
var CREDENTIALS = {
  appId: 67854,
   authKey: 'cQ3F2AYqFThBR5t',
   authSecret: 'tDrTBXv6Vp2w47E'
};


// debugger
QB.init(CREDENTIALS.appId, CREDENTIALS.authKey, CREDENTIALS.authSecret);

QB.createSession(function(err,result){
    if (result){
      var param_check_user= {email: [login_email]}
      QB.users.get(param_check_user, function(err, result){
          if (err) {
            var params = { 'login': user_firstname,'email': login_email, 'password': user_phone_number, 'tag_list': "DIALUCK",'full_name':user_fullname};
            QB.users.create(params, function(err, user){
                if (user) {
                    // user created
                    $.ajax({
                         url: '/update_chat_id',
                        type: 'get',
                        // headers: {Accept: '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'},
                         data: {
                           "QBuser_id":user.id
                         },

                         success: function(data) {
                           console.log("successfully updated chat_id")

                         },
                         error: function(err){
                           console.log("error in updating chat_id")


                         }
                     });

                } else  {
                  // debugger
                }
            });
          }
          else{
            if (user_chat_id=="-1"){
              console.log(user_chat_id)
              // user created
              $.ajax({
                   url: '/update_chat_id',
                  type: 'get',
                  // headers: {Accept: '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'},
                   data: {
                     "QBuser_id":result.id
                   },

                   success: function(data) {
                     console.log("successfully updated chat_id")

                   },
                   error: function(err){
                     console.log("error in updating chat_id")


                   }
               });

            }
          }
      });
    }
});
