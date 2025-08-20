import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

persistent actor {

  type Email = {
    id: Nat;
    subject: Text;
    from: Text;
    isRead: Bool;
    isSpam: Bool;
  };
  
  transient var inbox : Buffer.Buffer<Email> = Buffer.Buffer<Email>(10);
  transient var archive : Buffer.Buffer<Email> = Buffer.Buffer<Email>(10);
  transient var initialized : Bool = false;

  // Initialize sample inbox
  private func initInbox() {
    if (not initialized) {
      inbox.add({ id = 1; subject = "Important Update"; from = "team@dodo.com"; isRead = false; isSpam = false });
      inbox.add({ id = 2; subject = "Win a Free Prize!"; from = "asus@promo.com"; isRead = false; isSpam = true });
      inbox.add({ id = 3; subject = "Meeting Reminder"; from = "erica@gooogle.com"; isRead = false; isSpam = false });
      inbox.add({ id = 4; subject = "New on ICP"; from = "sales@icpio.com"; isRead = false; isSpam = false });
      inbox.add({ id = 5; subject = "Buy an iPhone for $5"; from = "iphone@iphone.com"; isRead = false; isSpam = true });
      initialized := true;
    };
  };

  public query func fetchAllEmails() : async [Email] {
    initInbox();
    return Buffer.toArray(inbox);
  };

  public query func getArchivedEmails() : async [Email] {
    return Buffer.toArray(archive);
  };

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

  public func markAsRead(id: Nat) : async Bool {
    initInbox();
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

  public func deleteEmail(id: Nat) : async Bool {
    initInbox();
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

  public func archiveEmail(id: Nat) : async Bool {
    initInbox();
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