import Main "./main";
import RunTest "./RunTest";
import Debug "mo:base/Debug";

actor TestRunner {
  
  public func executeTests() : async Text {
    Debug.print("Starting tests...");
    
    // Pass the main actor's functions to the test module
    await RunTest.runTests(
      Main.fetchAllEmails,
      Main.markAsRead,
      Main.deleteEmail,
      Main.archiveEmail,
      Main.getArchivedEmails
    );
    
    Debug.print("Tests completed.");
    return "All tests executed successfully";
  };
}