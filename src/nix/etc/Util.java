package nix.etc;

public class Util {
    private static final String greeting = "Hello";

    public static String makeGreeting(String name) {
        return Util.greeting + " " + name;
    }
}
