#!/bin/bash

# rename hostname from raspberrypi to qa
pirateship rename qa

# configure static global valid ip address
#pirateship ethernet 204.9.221.79 255.255.255.128 204.9.221.1 "204.9.221.30 204.9.223.18 204.9.223.19"
#sleep 10

# template for nation install
function nation {
  # s1 = name
  # s2 = port
  # s3 = version

  # create couchdb docker container
  docker run -d -p $2:5984 --name $1 -v /srv/data/$1:/usr/local/var/lib/couchdb -v /srv/log/$1:/usr/local/var/log/couchdb dogi/rpi-couchdb

  # download BeLL-Apps
  mkdir -p /root/ole/$3
  cd /root/ole/$3
  wget https://github.com/open-learning-exchange/BeLL-Apps/archive/0.11.$3.zip
  unzip *.zip
  ln -s BeLL-Apps-* BeLL-Apps
  cd BeLL-Apps
  chmod +x node_modules/.bin/couchapp

  # create install_linux
  echo "node_modules/.bin/couchapp push \$1 \$2" > pushDocToDb.sh
  chmod +x node_modules/.bin/couchapp pushDocToDb.sh
  cp install_windows install_linux
  sed -i "s/pushDocToDb.bat/.\/pushDocToDb.sh/" install_linux
  sed -i 's#databases\\\\#databases/#' install_linux
  sed -i 's/NationBell/'$1'QA/' init_docs/ConfigurationsDoc-Nation.txt
  sed -i 's/nationbell/'$1'/' init_docs/ConfigurationsDoc-Nation.txt

  # install nation
  node install_linux http://127.0.0.1:$2


  # overwrite some .couch with qa-content
  # docker stop $1
  # if [[ -e /data/download.ole.org/.qa/.content ]] ; then
  #   cp /data/download.ole.org/.qa/.content/*.couch /srv/data/$1/.
  # else
  #   wget http://download.ole.org/.qa/.content/collectionlist.couch -O /srv/data/$1/collectionlist.couch
  #   wget http://download.ole.org/.qa/.content/coursestep.couch -O /srv/data/$1/coursestep.couch
  #   wget http://download.ole.org/.qa/.content/groups.couch -O /srv/data/$1/groups.couch
  #   wget http://download.ole.org/.qa/.content/publications.couch -O /srv/data/$1/publications.couch
  #   wget http://download.ole.org/.qa/.content/resources.couch -O /srv/data/$1/resources.couch
  # fi
  # docker start $1
  # sleep 10

 # node_modules/.bin/couchapp push databases/groups.js http://127.0.0.1:$2/groups
 # node_modules/.bin/couchapp push databases/resources.js http://127.0.0.1:$2/resources
 # node_modules/.bin/couchapp push databases/publications.js http://127.0.0.1:$2/publications
 #node_modules/.bin/couchapp push databases/collectionlist.js http://127.0.0.1:$2/collectionlist
 # node_modules/.bin/couchapp push databases/coursestep.js http://127.0.0.1:$2/coursestep

  # add users
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"a","lastName":"a","middleNames":"a","login":"a","password":"a","phone":"a","email":"a@a","language":"","BirthDate":"2010-10-15T04:00:00.000Z","visits":0,"Gender":"Male","levels":"1","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"b","lastName":"b","middleNames":"b","login":"b","password":"b","phone":"b","email":"b@b","language":"","BirthDate":"2010-10-15T04:00:00.000Z","visits":0,"Gender":"Female","levels":"1","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"c","lastName":"c","middleNames":"c","login":"c","password":"c","phone":"c","email":"c@c","language":"","BirthDate":"2005-10-15T04:00:00.000Z","visits":0,"Gender":"Male","levels":"4","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"d","lastName":"d","middleNames":"d","login":"d","password":"d","phone":"d","email":"d@d","language":"","BirthDate":"2005-10-15T04:00:00.000Z","visits":0,"Gender":"Female","levels":"4","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"e","lastName":"e","middleNames":"e","login":"e","password":"e","phone":"e","email":"e@e","language":"","BirthDate":"2000-10-15T04:00:00.000Z","visits":0,"Gender":"Male","levels":"7","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"f","lastName":"f","middleNames":"f","login":"f","password":"f","phone":"f","email":"f@f","language":"","BirthDate":"2000-10-15T04:00:00.000Z","visits":0,"Gender":"Female","levels":"7","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"g","lastName":"g","middleNames":"g","login":"g","password":"g","phone":"g","email":"g@g","language":"","BirthDate":"1995-10-15T04:00:00.000Z","visits":0,"Gender":"Male","levels":"10","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"h","lastName":"h","middleNames":"h","login":"h","password":"h","phone":"h","email":"h@h","language":"","BirthDate":"1995-10-15T04:00:00.000Z","visits":0,"Gender":"Female","levels":"10","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"i","lastName":"i","middleNames":"i","login":"i","password":"i","phone":"i","email":"i@i","language":"","BirthDate":"1990-10-15T04:00:00.000Z","visits":0,"Gender":"Male","levels":"Higher","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'
  # curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:'$2'/members' --data '{"kind":"Member","roles":["Learner"],"firstName":"j","lastName":"j","middleNames":"j","login":"j","password":"j","phone":"j","email":"j@j","language":"","BirthDate":"1990-10-15T04:00:00.000Z","visits":0,"Gender":"Female","levels":"Higher","status":"active","yearsOfTeaching":null,"teachingCredentials":null,"subjectSpecialization":null,"forGrades":null,"community":"newnew","region":"","nation":"nation"}'

  # # set configs
  # curl -X POST -H "Content-Type: application/json" --data '{ "kind":"Community", "lastAppUpdateDate":" - ", "version":" - ", "lastActivitiesSyncDate":" - ", "lastPublicationsSyncDate":" - ", "Name":"old'$1'", "Code":"old'$1'", "Url":"'$1'.local:5984", "SponserName":"Organization", "SponserAddress":"Address", "ContactFirstname":"Jane", "ContactMiddlename":"", "ContactLastname":"Doe", "ContactPhone":"0123456789", "ContactEmail":"jane@doe", "LeaderFirstname":"John", "LeaderMiddlename":"", "LeaderLastname":"Doe", "LeaderPhone":"0123456789", "LeaderEmail":"john@doe", "LeaderId":"admin", "LeaderPassword":"password", "UrgentName":"dogi", "UrgentPhone":"ole.org", "AuthName":"dogi", "AuthDate":"1978-09-10" }' 'http://127.0.0.1:'$2'/community'
  # curl -X POST -H "Content-Type: application/json" --data '{ "kind":"Community", "lastAppUpdateDate":" - ", "version":" - ", "lastActivitiesSyncDate":" - ", "lastPublicationsSyncDate":" - ", "Name":"new'$1'", "Code":"new'$1'", "Url":"'$1'.local:5985", "SponserName":"Organization", "SponserAddress":"Address", "ContactFirstname":"Jane", "ContactMiddlename":"", "ContactLastname":"Doe", "ContactPhone":"0123456789", "ContactEmail":"jane@doe", "LeaderFirstname":"John", "LeaderMiddlename":"", "LeaderLastname":"Doe", "LeaderPhone":"0123456789", "LeaderEmail":"john@doe", "LeaderId":"admin", "LeaderPassword":"password", "UrgentName":"dogi", "UrgentPhone":"ole.org", "AuthName":"dogi", "AuthDate":"1978-09-10" }' 'http://127.0.0.1:'$2'/community'
  # curl -X POST -H "Content-Type: application/json" --data '{ "kind":"Community", "lastAppUpdateDate":" - ", "version":" - ", "lastActivitiesSyncDate":" - ", "lastPublicationsSyncDate":" - ", "Name":"travel", "Code":"TRAVEL", "Url":"travel.local:5984", "SponserName":"Organization", "SponserAddress":"Address", "ContactFirstname":"Jane", "ContactMiddlename":"", "ContactLastname":"Doe", "ContactPhone":"0123456789", "ContactEmail":"jane@doe", "LeaderFirstname":"John", "LeaderMiddlename":"", "LeaderLastname":"Doe", "LeaderPhone":"0123456789", "LeaderEmail":"john@doe", "LeaderId":"admin", "LeaderPassword":"password", "UrgentName":"dogi", "UrgentPhone":"ole.org", "AuthName":"dogi", "AuthDate":"1978-09-10" }' 'http://127.0.0.1:'$2'/community'
  # curl -X POST -H "Content-Type: application/json" --data '{ "kind":"Community", "lastAppUpdateDate":" - ", "version":" - ", "lastActivitiesSyncDate":" - ", "lastPublicationsSyncDate":" - ", "Name":"tesla", "Code":"TESLA", "Url":"tesla.local:5984", "SponserName":"Organization", "SponserAddress":"Address", "ContactFirstname":"Jane", "ContactMiddlename":"", "ContactLastname":"Doe", "ContactPhone":"0123456789", "ContactEmail":"jane@doe", "LeaderFirstname":"John", "LeaderMiddlename":"", "LeaderLastname":"Doe", "LeaderPhone":"0123456789", "LeaderEmail":"john@doe", "LeaderId":"admin", "LeaderPassword":"password", "UrgentName":"dogi", "UrgentPhone":"ole.org", "AuthName":"dogi", "AuthDate":"1978-09-10" }' 'http://127.0.0.1:'$2'/community'
  # for publication in `curl -X GET 'http://127.0.0.1:'$2'/publications/_all_docs' | tr '"' ' ' | sed "1d;$ d" | awk '{print $4}' | sed '/^_/ d'`
  # do
  #   curl -X POST -H "Content-Type: application/json" --data '{ "Viewed":false, "communityName":"old'$1'", "communityUrl":"old'$1'", "publicationId":"'$publication'" }' 'http://127.0.0.1:'$2'/publicationdistribution'
  #   curl -X POST -H "Content-Type: application/json" --data '{ "Viewed":false, "communityName":"new'$1'", "communityUrl":"new'$1'", "publicationId":"'$publication'" }' 'http://127.0.0.1:'$2'/publicationdistribution'
  #   curl -X POST -H "Content-Type: application/json" --data '{ "Viewed":false, "communityName":"travel", "communityUrl":"travel", "publicationId":"'$publication'" }' 'http://127.0.0.1:'$2'/publicationdistribution'
  #   curl -X POST -H "Content-Type: application/json" --data '{ "Viewed":false, "communityName":"tesla", "communityUrl":"tesla", "publicationId":"'$publication'" }' 'http://127.0.0.1:'$2'/publicationdistribution'
  # done
  curl -X PUT 'http://127.0.0.1:'$2'/_config/httpd/allow_jsonp' -d '"true"'
  #curl -X PUT 'http://127.0.0.1:'$2'/_config/httpd/enable_cors' -d '"true"'
  #curl -X PUT 'http://127.0.0.1:'$2'/_config/cors/origins' -d '"*"'
  curl -X PUT 'http://127.0.0.1:'$2'/_config/admins/nation' -d '"oleoleole"'

  # add to '/boot/autorun.sh'
  echo 'sleep 1' >> /boot/autorun.sh
  echo 'docker start '$1 >> /boot/autorun.sh

  # # add to proxy
  echo '"'$1'.qa.ole.org": "http://'$1'.qa.ole.org:'$2'/apps/_design/bell/MyApp/index.html",' >> /root/ole/server.temp
  echo '"'$3'.qa.ole.org": "http://'$3'.qa.ole.org:'$2'/apps/_design/bell/MyApp/index.html",' >> /root/ole/server.temp

}

# write '/boot/autrun.sh'
echo '#!/bin/sh' > /boot/autorun.sh
echo '' >> /boot/autorun.sh



# install an old and a new nation
nation old 5984 69
nation new 5985 74



# write proxy
echo '#!/usr/bin/env node' > /root/ole/server.js
echo '' >> /root/ole/server.js
echo "var express = require('express')" >> /root/ole/server.js
echo 'var PortJack = express()' >> /root/ole/server.js
echo 'PortJack.get(/^(.+)$/, function(req, res) {' >> /root/ole/server.js
echo 'var options = {' >> /root/ole/server.js
cat /root/ole/server.temp >> /root/ole/server.js
echo '"qa.ole.org": "http://ole.org/our-team/"' >> /root/ole/server.js
echo '}' >> /root/ole/server.js
echo 'if (options.hasOwnProperty(req.hostname)) {' >> /root/ole/server.js
echo "res.setHeader('Location', options[req.hostname])" >> /root/ole/server.js
echo '}' >> /root/ole/server.js
echo 'else {' >> /root/ole/server.js
echo "res.setHeader('Location', 'http://ole.org')" >> /root/ole/server.js
echo '}' >> /root/ole/server.js
echo 'res.statusCode = 302' >> /root/ole/server.js
echo 'res.end()' >> /root/ole/server.js
echo '})' >> /root/ole/server.js
echo 'PortJack.listen(80)' >> /root/ole/server.js
chmod +x /root/ole/server.js
cd /root/ole
npm install express

# add to '/boot/autorun.sh'
echo '' >> /boot/autorun.sh
echo 'node /root/ole/server.js' >> /boot/autorun.sh

sync
sync
sync

reboot
