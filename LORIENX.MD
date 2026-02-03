<!--firebase قاعدة رالبيانات الاكثر امان للإنتاج -->
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Products - قراءة عامة، كتابة للـ Admin فقط
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Orders - قراءة/كتابة للمستخدم نفسه أو Admin
    match /orders/{orderId} {
      allow read: if request.auth != null 
        && (resource.data.userId == request.auth.uid 
            || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      allow write: if request.auth != null 
        && (request.resource.data.userId == request.auth.uid 
            || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // Users - قراءة/كتابة للمستخدم نفسه أو Admin
    match /users/{userId} {
      allow read: if request.auth != null 
        && (request.auth.uid == userId 
            || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}