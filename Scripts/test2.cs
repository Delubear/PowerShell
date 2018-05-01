public class Yell
{
    public string Hello()
    {
        return "Hello there!";
    }

    public string Hello(string str)
    {
        return "Hello " + str;
    }

    public static string Eat()
    {
        return "Food";
    }
}

public class Cards
{
    public string Name { get; set; }

    public string GetName()
    {
        return Name;
    }
}