
public interface ITicker
{
    int TicksToWait {get;set;}
    void DecreaseTicks();
    void DecreaseTicks(int ticks);
    string TakeAction();

    string Name {get;set;}
}

public class Food : ITicker
{
    public int TicksToWait {get;set;}
    public string Name {get;set;}
    public void DecreaseTicks()
    {
        TicksToWait--;
    }
    public void DecreaseTicks(int ticks)
    {
        TicksToWait -= ticks;
    }
    public string TakeAction()
    {
        return "Took an action";
    }
}