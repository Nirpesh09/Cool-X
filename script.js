const splash = document.getElementById('splash');
const auth = document.getElementById('auth');
const main = document.getElementById('main');
const otpBlock = document.getElementById('otpBlock');
const sendOtp = document.getElementById('sendOtp');
const verifyOtp = document.getElementById('verifyOtp');
const navButtons = [...document.querySelectorAll('.nav-btn')];
const panes = [...document.querySelectorAll('.pane')];
const screenTitle = document.getElementById('screenTitle');
const subTitle = document.getElementById('subTitle');
const themeToggle = document.getElementById('themeToggle');
const fab = document.getElementById('fab');
const chatDrawer = document.getElementById('chatDrawer');
const chatList = document.getElementById('chatList');
const messageArea = document.getElementById('messageArea');
const messageInput = document.getElementById('messageInput');
const sendBtn = document.getElementById('sendBtn');
const backBtn = document.getElementById('backBtn');
const creatorDialog = document.getElementById('creatorDialog');
const creatorTitle = document.getElementById('creatorTitle');
const creatorName = document.getElementById('creatorName');
const creatorDesc = document.getElementById('creatorDesc');
const creatorSave = document.getElementById('creatorSave');
const groupCards = document.getElementById('groupCards');
const channelCards = document.getElementById('channelCards');
const callList = document.getElementById('callList');

const state = {
  currentTab: 'chats',
  currentChat: null,
  chats: [
    { id: 1, name: 'Ava Wilson', last: 'Can we ship the feature tonight?', unread: 2, online: true },
    { id: 2, name: 'Leo Product', last: 'Poll: Launch on Friday?', unread: 0, online: false },
    { id: 3, name: 'Nora Design', last: 'Sent a sticker', unread: 1, online: true },
    { id: 4, name: 'DevOps Bot', last: 'Build succeeded ✅', unread: 0, online: true }
  ],
  messages: {
    1: [
      { type: 'incoming', text: 'Hey! Typing indicator looks smooth 👀' },
      { type: 'outgoing', text: 'Thanks! Added 60fps transitions.' },
      { type: 'incoming', text: 'Love it. Let’s add reactions + polls next.' }
    ],
    2: [
      { type: 'incoming', text: 'Reminder: scheduled post at 6:30 PM.' },
      { type: 'outgoing', text: 'Pinned. I also enabled silent posting.' }
    ]
  },
  groups: [
    { name: 'Product Team', desc: 'Mentions, hashtags, pinned roadmap', members: 1220 },
    { name: 'Cool-X Community', desc: 'Sub-groups + announcement channel', members: 18234 }
  ],
  channels: [
    { name: 'Release Notes', desc: 'One-way updates with analytics', subs: 45210 },
    { name: 'Design Tips', desc: 'Scheduled posts and media', subs: 10988 }
  ],
  calls: [
    { who: 'Ava Wilson', kind: 'Video • 12 min' },
    { who: 'Nora Design', kind: 'Voice • Missed' },
    { who: 'Product Team', kind: 'Group Call • 31 min' }
  ]
};

setTimeout(() => {
  splash.classList.remove('active');
  auth.classList.add('active');
}, 2600);

sendOtp.addEventListener('click', () => {
  if (!document.getElementById('phoneInput').value.trim()) return;
  otpBlock.classList.remove('hidden');
});

verifyOtp.addEventListener('click', () => {
  if (document.getElementById('otpInput').value.length !== 6) return;
  auth.classList.remove('active');
  main.classList.add('active');
  renderAll();
});

function renderAll() {
  renderChats();
  renderCards(groupCards, state.groups, 'members');
  renderCards(channelCards, state.channels, 'subs');
  callList.innerHTML = state.calls.map(c => `<li><span>${c.who}</span><small>${c.kind}</small></li>`).join('');
}

function renderChats(search = '') {
  const filtered = state.chats.filter(c => (`${c.name} ${c.last}`).toLowerCase().includes(search.toLowerCase()));
  chatList.innerHTML = filtered.map(chat => `
    <article class="chat-item" data-id="${chat.id}">
      <div>
        <strong>${chat.name}</strong>
        <div><small>${chat.last}</small></div>
      </div>
      <div style="text-align:right">
        <small>${chat.online ? 'online' : 'last seen 2h'}</small>
        <div>${chat.unread ? `🔵 ${chat.unread}` : '✓✓'}</div>
      </div>
    </article>
  `).join('');
}

function renderCards(root, items, metric) {
  root.innerHTML = items.map(i => `
    <article class="card-row">
      <strong>${i.name}</strong>
      <div><small>${i.desc}</small></div>
      <small>${i[metric].toLocaleString()} ${metric}</small>
    </article>
  `).join('');
}

navButtons.forEach(btn => {
  btn.addEventListener('click', () => {
    const tab = btn.dataset.tab;
    state.currentTab = tab;
    navButtons.forEach(b => b.classList.toggle('active', b === btn));
    panes.forEach(p => p.classList.toggle('active', p.dataset.screen === tab));
    screenTitle.textContent = tab[0].toUpperCase() + tab.slice(1);
    subTitle.textContent = ({ chats: '2,413 online', groups: 'Manage communities', channels: 'Broadcast updates', calls: 'End-to-end encrypted', settings: 'Privacy + theme controls' })[tab];
    fab.textContent = tab === 'chats' ? '＋' : tab === 'groups' ? '👥' : tab === 'channels' ? '📢' : tab === 'calls' ? '📞' : '✎';
  });
});

document.getElementById('globalSearch').addEventListener('input', e => renderChats(e.target.value));

themeToggle.addEventListener('click', () => {
  document.getElementById('app').classList.toggle('theme-dark');
});

chatList.addEventListener('click', (e) => {
  const item = e.target.closest('.chat-item');
  if (!item) return;
  const id = item.dataset.id;
  const chat = state.chats.find(c => c.id == id);
  state.currentChat = id;
  document.getElementById('chatTitle').textContent = chat.name;
  document.getElementById('chatStatus').textContent = chat.online ? 'typing…' : 'last seen recently';
  loadMessages();
  chatDrawer.classList.add('open');
});

function loadMessages() {
  messageArea.innerHTML = (state.messages[state.currentChat] || []).map(m => `
    <div class="bubble ${m.type}">${m.text}<div><small>😊 👍 🔥</small></div></div>
  `).join('');
  messageArea.scrollTop = messageArea.scrollHeight;
}

sendBtn.addEventListener('click', sendMessage);
messageInput.addEventListener('keydown', e => {
  if (e.key === 'Enter') sendMessage();
});

function sendMessage() {
  const text = messageInput.value.trim();
  if (!text || !state.currentChat) return;
  state.messages[state.currentChat] ||= [];
  state.messages[state.currentChat].push({ type: 'outgoing', text });
  messageInput.value = '';
  loadMessages();
  setTimeout(() => {
    state.messages[state.currentChat].push({ type: 'incoming', text: 'Auto-reply: Delivered instantly ⚡' });
    loadMessages();
  }, 700);
}

backBtn.addEventListener('click', () => chatDrawer.classList.remove('open'));

let creatorMode = 'group';
document.getElementById('newGroup').addEventListener('click', () => openCreator('group'));
document.getElementById('newChannel').addEventListener('click', () => openCreator('channel'));
fab.addEventListener('click', () => {
  if (state.currentTab === 'groups') return openCreator('group');
  if (state.currentTab === 'channels') return openCreator('channel');
  if (state.currentTab === 'chats') {
    chatDrawer.classList.add('open');
    state.currentChat = '1';
    loadMessages();
  }
});

function openCreator(mode) {
  creatorMode = mode;
  creatorTitle.textContent = mode === 'group' ? 'Create Group' : 'Create Channel';
  creatorName.value = '';
  creatorDesc.value = '';
  creatorDialog.showModal();
}

creatorSave.addEventListener('click', (e) => {
  e.preventDefault();
  const entry = {
    name: creatorName.value || `New ${creatorMode}`,
    desc: creatorDesc.value || 'Created from quick action',
    [creatorMode === 'group' ? 'members' : 'subs']: 1
  };
  if (creatorMode === 'group') {
    state.groups.unshift(entry);
    renderCards(groupCards, state.groups, 'members');
  } else {
    state.channels.unshift(entry);
    renderCards(channelCards, state.channels, 'subs');
  }
  creatorDialog.close();
});
