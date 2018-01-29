
var CREDENTIALS = {
  appId: 67854,
  authKey: 'cQ3F2AYqFThBR5t',
  authSecret: 'tDrTBXv6Vp2w47E'

};
QB.init(CREDENTIALS.appId, CREDENTIALS.authKey, CREDENTIALS.authSecret);

QB.createSession(function(err,result){
    if (result){
      var param_check_user= {login: [login_email]}
      QB.users.get(param_check_user, function(err, result){

          if (err) {
            var params = { 'login': login_email, 'password': login_email, 'tag_list': "DIALUCK",'full_name':user_fullname};
            QB.users.create(params, function(err, user){
                if (user) {
                    // user created
                } else  {
                  // debugger
                }
            });
          }
      });
    }
});
