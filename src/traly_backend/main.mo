import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor {

  type Email = {
    id: Nat;
    subject: Text;
    from: Text;
    isRead: Bool;
    isSpam: Bool;
  };

  transient var inbox : Buffer.Buffer<Email> = Buffer.Buffer<Email>(10);
  transient var archive : Buffer.Buffer<Email> = Buffer.Buffer<Email>(10);

  // Initialize sample inbox
  private func initInbox() {
    inbox.add({ id = 1; subject = "Important Update"; from = "team@example.com"; isRead = false; isSpam = false });
    inbox.add({ id = 2; subject = "Win a Free Prize!"; from = "spam@example.com"; isRead = false; isSpam = true });
    inbox.add({ id = 3; subject = "Meeting Reminder"; from = "boss@example.com"; isRead = false; isSpam = false });
  };

  // Function to fetch all emails from inbox
  public query func fetchAllEmails() : async [Email] {
    Buffer.toArray(inbox);
  };

  // Helper to find email index by ID
  private func findEmailIndex(id: Nat) : ?Nat {
    var index : Nat = 0;
    for (email in inbox.vals()) {
      if (email.id == id) {
        return ?index;
      };
      index += 1;
    };
    null;
  };

  // Mark an email as read
  public func markAsRead(id: Nat) : async Bool {
    switch (findEmailIndex(id)) {
      case (?index) {
        let email = inbox.get(index);
        inbox.put(index, { email with isRead = true });
        true;
      };
      case null {
        false;
      };
    };
  };

  // Delete an email
  public func deleteEmail(id: Nat) : async Bool {
    switch (findEmailIndex(id)) {
      case (?index) {
        ignore inbox.remove(index);
        true;
      };
      case null {
        false;
      };
    };
  };

  // Archive an email (remove from inbox, add to archive)
  public func archiveEmail(id: Nat) : async Bool {
    switch (findEmailIndex(id)) {
      case (?index) {
        let email = inbox.remove(index);
        archive.add(email);
        true;
      };
      case null {
        false;
      };
    };
  };

// Test section: Run actions and log results incrementally
  public func runTests() : async () {
    initInbox();

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
    for (email in archive.vals()) {
      Debug.print("ID: " # Nat.toText(email.id) # ", Subject: " # email.subject # ", From: " # email.from # ", isRead: " # debug_show(email.isRead) # ", isSpam: " # debug_show(email.isSpam));
    };
  };
};