import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoolXApp());
}

class CoolXApp extends StatefulWidget {
  const CoolXApp({super.key});

  @override
  State<CoolXApp> createState() => _CoolXAppState();
}

class _CoolXAppState extends State<CoolXApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool dark) {
    setState(() {
      _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      splashFactory: InkRipple.splashFactory,
    );

    return MaterialApp(
      title: 'Cool X Messenger',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: base.copyWith(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A74FF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: base.copyWith(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A74FF),
          brightness: Brightness.dark,
        ),
      ),
      home: SplashScreen(onFinished: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AuthScreen(onLogin: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HomeShell(
                    themeMode: _themeMode,
                    onThemeToggle: _toggleTheme,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    Timer(const Duration(milliseconds: 2200), widget.onFinished);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005BFF), Color(0xFF5AA8FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.paperplane_fill,
                    size: 72, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Cool X',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 38,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _GradientBackdrop(),
          Center(
            child: GlassCard(
              width: 380,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Login / Signup',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixText: '+1 ',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: onLogin, child: const Text('Request OTP')),
                    const SizedBox(height: 8),
                    Text(
                      'Demo: one tap enters prototype',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell(
      {super.key, required this.themeMode, required this.onThemeToggle});
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeToggle;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ChatsScreen(onOpenChat: _openConversation),
      const GroupsScreen(),
      const ChannelsScreen(),
      const CallsScreen(),
      SettingsScreen(
        isDark: Theme.of(context).brightness == Brightness.dark,
        onThemeToggle: widget.onThemeToggle,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _index == 1
            ? _openCreateGroup
            : _index == 2
                ? _openCreateChannel
                : _openConversation,
        icon: const Icon(Icons.add_comment_rounded),
        label: Text(_index == 1
            ? 'New Group'
            : _index == 2
                ? 'New Channel'
                : 'New Message'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Groups'),
          NavigationDestination(icon: Icon(Icons.campaign_outlined), label: 'Channels'),
          NavigationDestination(icon: Icon(Icons.call_outlined), label: 'Calls'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  void _openConversation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatConversationScreen()),
    );
  }

  void _openCreateGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GroupCreateScreen()),
    );
  }

  void _openCreateChannel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChannelCreateScreen()),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key, required this.onOpenChat});
  final VoidCallback onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _GradientBackdrop(),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('Chats', style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search messages, links, files',
                    prefixIcon: const Icon(Icons.manage_search_rounded),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 12,
                  itemBuilder: (_, i) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + i * 30),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: GlassCard(
                        child: ListTile(
                          onTap: onOpenChat,
                          leading: CircleAvatar(
                            radius: 22,
                            child: Text(String.fromCharCode(65 + (i % 26))),
                          ),
                          title: Text('Contact ${i + 1}'),
                          subtitle: Text(i.isEven
                              ? 'Typing...'
                              : 'Let\'s meet at 7:30 PM with files attached.'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${(i + 1) % 12 + 1}:2${i % 6}'),
                              const SizedBox(height: 4),
                              if (i % 3 == 0)
                                const Icon(Icons.done_all,
                                    color: Color(0xFF2A74FF), size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({super.key});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final messages = <String>[
    'Hey! This is a premium Telegram-inspired prototype.',
    'Voice, video bubble, files, polls, stickers and reactions supported (UI).',
    'Swipe a message to reply. Tap-hold mic for voice.',
  ];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Nora Williams'),
          subtitle: Text('online • typing...'),
          leading: CircleAvatar(child: Icon(Icons.person)),
        ),
        actions: const [
          Icon(Icons.videocam_outlined),
          SizedBox(width: 12),
          Icon(Icons.call_outlined),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          const _GradientBackdrop(),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final text = messages[messages.length - 1 - i];
                    final mine = i.isEven;
                    return Dismissible(
                      key: ValueKey('$i$text'),
                      direction: DismissDirection.startToEnd,
                      background: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.reply),
                        ),
                      ),
                      confirmDismiss: (_) async => false,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 220 + i * 70),
                        builder: (_, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(24 * (1 - value), 0),
                            child: child,
                          ),
                        ),
                        child: Align(
                          alignment:
                              mine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            padding: const EdgeInsets.all(14),
                            constraints: const BoxConstraints(maxWidth: 320),
                            decoration: BoxDecoration(
                              color: mine
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(text),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('👍 ❤️ 😂'),
                                    const SizedBox(width: 10),
                                    Icon(mine ? Icons.done_all : Icons.done,
                                        size: 14,
                                        color: const Color(0xFF2A74FF)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recording voice...')),
                          );
                        },
                        child: FloatingActionButton.small(
                          onPressed: _send,
                          child: const Icon(Icons.send_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _send() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(controller.text.trim());
      controller.clear();
    });
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimplePanel(
      title: 'Groups',
      subtitle:
          'Mentions, hashtags, admin roles, invite links, pinned messages and large member support.',
    );
  }
}

class GroupCreateScreen extends StatelessWidget {
  const GroupCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateEntityScreen(
      title: 'Create Group',
      fields: ['Group name', 'Description', 'Invite link', 'Permissions'],
    );
  }
}

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimplePanel(
      title: 'Channels',
      subtitle:
          'Broadcast posts, silent publish, schedule posts, analytics and unlimited subscribers.',
    );
  }
}

class ChannelCreateScreen extends StatelessWidget {
  const ChannelCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateEntityScreen(
      title: 'Create Channel',
      fields: ['Channel name', 'About', 'Post schedule', 'Silent posting'],
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _GradientBackdrop(),
        SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Calls', style: Theme.of(context).textTheme.headlineMedium),
                trailing: const Icon(Icons.wifi_calling_3_rounded),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (_, i) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Call contact ${i + 1}'),
                    subtitle: Text(i.isEven ? 'HD Voice • 3 min ago' : 'Video • Yesterday'),
                    trailing: Icon(i.isEven ? Icons.call : Icons.videocam),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CircleAvatar(radius: 46, child: Icon(Icons.person, size: 42)),
          SizedBox(height: 16),
          ListTile(title: Text('Username'), subtitle: Text('@coolx_user')),
          ListTile(title: Text('Bio'), subtitle: Text('Building the future of messaging')),
          ListTile(title: Text('Privacy'), subtitle: Text('Last seen: My contacts')),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(
      {super.key, required this.isDark, required this.onThemeToggle});
  final bool isDark;
  final ValueChanged<bool> onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _GradientBackdrop(),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: isDark,
                      onChanged: onThemeToggle,
                      title: const Text('Dark mode'),
                    ),
                    const ListTile(
                      title: Text('Passcode & Biometrics'),
                      subtitle: Text('Enable lock + face/fingerprint unlock'),
                    ),
                    const ListTile(
                      title: Text('Data & Storage'),
                      subtitle: Text('Cloud sync, offline queue, media auto-download'),
                    ),
                    ListTile(
                      title: const Text('Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen())),
                    ),
                    ListTile(
                      title: const Text('Media Viewer Demo'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const MediaViewerScreen())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MediaViewerScreen extends StatelessWidget {
  const MediaViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Viewer')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0E18), Color(0xFF1D2E56)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Hero(
            tag: 'media',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 300,
                height: 420,
                color: Colors.white10,
                child: const Center(
                  child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimplePanel extends StatelessWidget {
  const _SimplePanel({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _GradientBackdrop(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(subtitle),
                    const SizedBox(height: 12),
                    const Text('Community mode: category-based subgroups + announcement links.'),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _CreateEntityScreen extends StatelessWidget {
  const _CreateEntityScreen({required this.title, required this.fields});
  final String title;
  final List<String> fields;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final field in fields)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: field,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('Create')),
        ],
      ),
    );
  }
}

class _GradientBackdrop extends StatelessWidget {
  const _GradientBackdrop();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? [const Color(0xFF0D1220), const Color(0xFF142B5A), const Color(0xFF1E1E24)]
              : [const Color(0xFFDCEAFF), Colors.white, const Color(0xFFE7F1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.width,
  });

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.68),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
