using OpenQA.Selenium;

namespace SeleniumTests.PageObjects
{
    public class LoginPage : BasePage
    {
        private IWebElement UsernameField => Driver.FindElement(By.Id("username"));
        private IWebElement PasswordField => Driver.FindElement(By.Id("password"));
        private IWebElement LoginButton => Driver.FindElement(By.Id("login-button"));

        public LoginPage(IWebDriver driver) : base(driver) { }

        public override bool IsAt()
        {
            return UsernameField.Displayed && PasswordField.Displayed && LoginButton.Displayed;
        }

        public void Login(string username, string password)
        {
            UsernameField.SendKeys(username);
            PasswordField.SendKeys(password);
            LoginButton.Click();
        }
    }
}
