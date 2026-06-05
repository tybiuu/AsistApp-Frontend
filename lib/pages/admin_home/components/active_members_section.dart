// lib/pages/admin_home/components/active_members_section.dart

import 'package:flutter/material.dart';

import 'admin_member_tile.dart';
import '../../../models/user.dart';

class ActiveMembersSection extends StatelessWidget {
  final List<User> members;
  final ValueChanged<User> onMemberTap;

  const ActiveMembersSection({
    super.key,
    required this.members,
    required this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Miembros activos',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...members.map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminMemberTile(
              member: member,
              onTap: () => onMemberTap(member),
            ),
          ),
        ),
      ],
    );
  }
}
