HTML_FILES=$(shell find app -name '*.jade' | sed s/jade/html/)
JS_FILES=server/app.js server/main.js lib/schema.js

.jade.html:
	jade --pretty $<

.ls.js:
	env PATH="$$PATH:./node_modules/LiveScript/bin" livescript -c  $<

all :: $(HTML_FILES) $(JS_FILES)
	env PATH="$$PATH:./node_modules/brunch/bin" brunch b

run :: all
	node server/app.js

heroku :: all
	rm -rf _public && git checkout heroku && git merge master && scripts/compile-jade.sh && brunch b -m && git add -A -f server lib _public && git commit -m 'regen' && git push heroku heroku:master -f && git checkout master

.SUFFIXES: .jade .html .ls .js
