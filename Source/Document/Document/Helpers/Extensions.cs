using System;

namespace Document.Helpers
{
    static class Extensions
    {
        public static string GetExceptionMessages(this Exception ex, string messages = "")
        {
            if (ex == null)
                return string.Empty;

            if (messages == "")
                messages = ex.Message;

            if (ex.InnerException != null)
                messages += "\r\n" + GetExceptionMessages(ex.InnerException);

            return messages;
        }
    }
}
