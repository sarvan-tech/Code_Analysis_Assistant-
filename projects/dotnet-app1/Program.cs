using System;
using System.Web; // Old namespace

class Program {
    static void Main() {
        Console.WriteLine("Hello from .NET Framework!");
        string encoded = HttpUtility.HtmlEncode("<script>alert('xss')</script>");
        Console.WriteLine(encoded);
    }
}