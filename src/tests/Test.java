package tests;

public class Test {
  public static void main(String[] args) {
    if ( ! nix.etc.Util.makeGreeting("world").equals("Hello world") ) {
      System.err.println("Test failed");
      System.exit(1);
    } else {
      System.err.println("Test succeeded");
    }
  }
}
