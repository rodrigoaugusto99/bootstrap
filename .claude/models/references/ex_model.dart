// ── lib/utils/enums.dart ──────────────────────────────────────────────────────
enum UserStatus {
  pendingApproval,
  approved,
  rejected,
  rejectedRetry;
}


// ── lib/models/user_model.dart ────────────────────────────────────────────────
class UserModel {
  final String id;
  final String name;
  final String email;
  final String status;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  // Getter de enum para campo com valores pré-definidos
  UserStatus get userStatus {
    switch (status) {
      case 'pending_approval':
        return UserStatus.pendingApproval;
      case 'rejected':
        return UserStatus.rejected;
      case 'rejected_retry':
        return UserStatus.rejectedRetry;
      case 'approved':
        return UserStatus.approved;
      default:
        return UserStatus.approved;
    }
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? 'approved',
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}


// ── Uso do getter (nunca compare strings diretamente) ─────────────────────────
if (user.userStatus == UserStatus.pendingApproval) {
  // aguardando aprovação
}

switch (user.userStatus) {
  case UserStatus.approved:
    // liberar acesso
  case UserStatus.rejected:
    // bloquear
  case UserStatus.rejectedRetry:
    // permitir nova tentativa
  case UserStatus.pendingApproval:
    // mostrar tela de espera
}
