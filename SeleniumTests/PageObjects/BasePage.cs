using OpenQA.Selenium;

namespace SeleniumTests.PageObjects
{
    public abstract class BasePage
    {
        protected IWebDriver Driver;

        protected BasePage(IWebDriver driver)
        {
            Driver = driver;
        }

        public abstract bool IsAt();
    }
}
