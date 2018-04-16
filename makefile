privkey=$(HOME)/.ssh/id_rsa
dotfiles=$(HOME)/dotfiles
ratpoisonrc=$(HOME)/.ratpoisonrc
vimrc=$(HOME)/.vimrc
bashrc=$(HOME)/.bashrc
gitconfig=$(HOME)/.gitconfig
muttrc=$(HOME)/.muttrc
tmux.conf=$(HOME)/.tmux.conf
dotfiles_repo=jbaber/dotfiles.git
local=$(HOME)/.local

all: ${ratpoisonrc} ${vimrc} ${bashrc} ${gitconfig} ${tmux.conf}

${privkey}:
	ssh-keygen -t rsa -b 2048
	@echo Paste this into github
	@echo
	@cat $(HOME)/.ssh/id_rsa.pub

${dotfiles}: ${privkey}
	ssh-agent
	ssh-add
	git clone git@github.com:${dotfiles_repo} ${dotfiles}

$(HOME)/.ratpoisonrc: ${dotfiles}
	cp -s ${dotfiles}/ratpoisonrc $(HOME)/.ratpoisonrc

$(HOME)/.vimrc: ${dotfiles}
	cp -s ${dotfiles}/vimrc $(HOME)/.vimrc

$(HOME)/.bashrc: ${dotfiles}
	mv -i $(HOME)/.bashrc $(HOME)/.bashrc.$$(date +%s)
	cp -s ${dotfiles}/bashrc $(HOME)/.bashrc

$(HOME)/.gitconfig: ${dotfiles} ${local}/conf/gitconfig
	cp -s ${dotfiles}/gitconfig $(HOME)/.gitconfig

${local}/conf/gitconfig: ${local}/conf
	touch ${local}/conf/gitconfig
	echo '[user]' >> ${local}/conf/gitconfig
	@echo -n 'What e-mail address do you want associated with git? '; \
	read email_address; \
	echo '  email = '$$email_address >> ${local}/conf/gitconfig
	@echo -n 'What name do you want associated with git? '; \
	read name ; \
	echo -n '  name = '$$name >> ${local}/conf/gitconfig
	@echo >> ${local}/conf/gitconfig
	echo '[github]' >> ${local}/conf/gitconfig
	@echo -n 'What is your github username? '; \
	read github_user; \
	echo '  user = '$$github_user >> ${local}/conf/gitconfig


${local}/conf: ${local}
	mkdir -p ${local}/conf

${local}:
	mkdir -p $(HOME)/.local

$(HOME)/.muttrc: ${dotfiles}
	cp -s ${dotfiles}/muttrc $(HOME)/.muttrc

$(HOME)/.tmux.conf: ${dotfiles}
	cp -s ${dotfiles}/tmux $(HOME)/.tmux
