package nix.etc;

public class Util {
    private static final String greeting = "Hello";

    public static String makeGreeting(String name) {
        assert false : "This should only be an error in 'debug' mode";
        return Util.greeting + " " + name;
    }
}
