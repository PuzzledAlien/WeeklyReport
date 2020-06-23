using Microsoft.AspNetCore.Mvc.Razor;
using System.IO;

namespace Enterprise.Web.Helpers
{
    public class HelperPage
    {
        public static void WriteTo(TextWriter writer, object value)
        {
            WebPageExecutingBase.WriteTo(writer, value);
        }

        public static void WriteLiteralTo(TextWriter writer, object value)
        {
            WebPageExecutingBase.WriteLiteralTo(writer, value);
        }

        public static void WriteTo(TextWriter writer, HelperResult value)
        {
            WebPageExecutingBase.WriteTo(writer, value);
        }

        public static void WriteLiteralTo(TextWriter writer, HelperResult value)
        {
            WebPageExecutingBase.WriteLiteralTo(writer, value);
        }

        public static void WriteAttributeTo(TextWriter writer, string name, PositionTagged<string> prefix, PositionTagged<string> suffix, params AttributeValue[] values)
        {
            WebPageExecutingBase.WriteAttributeTo(writer, name, prefix, suffix, values);
        }
    }
}
