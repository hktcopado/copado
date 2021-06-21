@isTest
private class HelloWorldTest {
    @isTest static void testhello() {
        HelloWorld hello_world = new HelloWorld();
        String result = hello_world.hello();
    }
}