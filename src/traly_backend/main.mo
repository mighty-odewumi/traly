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

};