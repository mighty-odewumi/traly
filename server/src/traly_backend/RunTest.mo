import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

module {
  
  public func runTests(
    fetchAllEmails: () -> async [{ id: Nat; subject: Text; from: Text; isRead: Bool; isSpam: Bool }],
    markAsRead: (Nat) -> async Bool,
    deleteEmail: (Nat) -> async Bool,
    archiveEmail: (Nat) -> async Bool,
    getArchivedEmails: () -> async [{ id: Nat; subject: Text; from: Text; isRead: Bool; isSpam: Bool }]
  ) : async () {

    Debug.print("Initial inbox:");
    let initialEmails = await fetchAllEmails();
    for (email in Iter.fromArray(initialEmails)) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };

    ignore await markAsRead(1);
    Debug.print("After marking email 1 as read:");
    let afterReadEmails = await fetchAllEmails();
    for (email in Iter.fromArray(afterReadEmails)) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };

    ignore await deleteEmail(2);
    Debug.print("After deleting email 2:");
    let afterDeleteEmails = await fetchAllEmails();
    for (email in Iter.fromArray(afterDeleteEmails)) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };

    ignore await archiveEmail(3);
    Debug.print("After archiving email 3:");
    let afterArchiveEmails = await fetchAllEmails();
    for (email in Iter.fromArray(afterArchiveEmails)) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };
    
    Debug.print("Archived emails:");
    let archivedEmails = await getArchivedEmails();
    for (email in Iter.fromArray(archivedEmails)) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };
  };
}