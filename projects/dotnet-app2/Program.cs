using System;
using System.Net.Http;

class Program {
    static void Main() {
        HttpClient client = new HttpClient();
        var response = client.GetStringAsync("https://example.com").Result; // Blocking call
        Console.WriteLine(response);
    }
}