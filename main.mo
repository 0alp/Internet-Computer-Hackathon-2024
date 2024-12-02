import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor Superheroes {

  /**
   * Types
   */

  // The type of a superhero identifier.
  public type SuperheroId = Nat32;

  // The type of a superhero.
  public type Product = {
  title: Text;  // Ürünün adı
  description: Text;  // Ürün açıklaması
  price: Nat32;  // Ürün fiyatı
  category: Text;  // Ürün kategorisi (örneğin "Elektronik", "Mobilya", vs.)
  seller: Text;  // Satıcının adı
  photos: List.List<Text>;  // Ürün fotoğraflarının URL'leri
};
  /**
   * Application State
   */

  // The next available superhero identifier.
  private stable var next : SuperheroId = 0;

  // The superhero data store.
private stable var products : Trie.Trie<Nat32, Product> = Trie.empty();
  /**
   * High-Level API
   */

  // Create a superhero.
  public func create(product : Product) : async Nat32 {
    let productId = next;
    next += 1;
    products := Trie.replace(
      products,
      key(productId),
      Nat32.equal,
      ?product
    ).0;
    return productId;
};

  public query func read(productId: Nat32) : async ?Product {
    let result = Trie.find(products, key(productId), Nat32.equal);
    return result;
};

 public func update(productId: Nat32, product: Product) : async Bool {
    let result = Trie.find(products, key(productId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
        products := Trie.replace(
            products,
            key(productId),
            Nat32.equal,
            ?product
        ).0;
    };
    return exists;
};

  public func delete(productId: Nat32) : async Bool {
    let result = Trie.find(products, key(productId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
        products := Trie.replace(
            products,
            key(productId),
            Nat32.equal,
            null
        ).0;
    };
    return exists;
};

  /**
   * Utilities
   */

  // Create a trie key from a superhero identifier.
  private func key(x : SuperheroId) : Trie.Key<SuperheroId> {
    return { hash = x; key = x };
  };
};
