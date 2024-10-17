using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using SeleniumTests.PageObjects;

namespace SeleniumTests.Tests
{
    [TestClass]
    public class LoginTests
    {
        private IWebDriver _driver;

        [TestInitialize]
        public void TestInitialize()
        {
            _driver = new ChromeDriver();
        }

        [TestMethod]
        public void SuccessfulLogin()
        {
            _driver.Navigate().GoToUrl("https://your-application-url.com");
            var loginPage = new LoginPage(_driver);
            Assert.IsTrue(loginPage.IsAt(), "Not on the login page");

            loginPage.Login("testuser", "testpassword");

            // Add assertions for successful login
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _driver.Quit();
        }
    }
}
