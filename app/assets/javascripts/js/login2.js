var loginModule = new Login();
if(!loginModule.isLogin) {
          Login.prototype.setListeners = function(){
              var self = this,
              loginForm = document.forms.loginForm,
              formInputs = ["dsddvfv", "mndsnfj"],
              loginBtn = loginForm.login_submit;

              // var userName = user,
              //     userGroup = "chat";

              var user = {
                  login: user_firstname,
                  email: user_email,
                  password: user_phone_number,
                  full_name: user_name,
                  tag_list: "DIALUCK"
              };

              localStorage.setItem('user', JSON.stringify(user));

              self.login(user).then(function(){
                  router.navigate('/dashboard');
              }).catch(function(error){
                  alert('lOGIN ERROR\n open console to get more info');
                  loginBtn.removeAttribute('disabled');
                  console.error(error);
                  loginForm.login_submit.innerText = 'LOGIN';
              });
            }

      };
Login.prototype.renderLoginPage = function(){
    helpers.clearView(app.page);

    app.page.innerHTML = helpers.fillTemplate('tpl_login', {
        version: QB.version
    });
    this.isLoginPageRendered = true;
    this.setListeners();
};

Login.prototype.renderLoadingPage = function(){
    helpers.clearView(app.page);
    app.page.innerHTML = helpers.fillTemplate('tpl_loading');
};
