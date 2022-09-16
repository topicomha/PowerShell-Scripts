git branch -r | `
        Select-Object -Skip 1 | `
        ForEach-Object {$_.replace("  origin/", "")} | `
        Out-GridView -Title "remote branches" -PassThru

Git Propertiers?
        refname: %(refname) 
        objecttype: %(objecttype) 
        objectsize: %(objectsize)
        objectname: %(objectname) 
        tree: %(tree) 
        parent: %(parent) 
        numparent: %(numparent)
        object: %(object) 
        type: %(type) 
        tag: %(tag) 
        author: %(author) 
        authorname: %(authorname) 
        authoremail: %(authoremail) 
        authordate: %(authordate)
        committer: %(committer) 
        committername: %(committername) 
        committeremail: %(committeremail) 
        committerdate: %(committerdate)
        tagger: %(tagger) 
        taggername: %(taggername) 
        taggeremail: %(taggeremail) 
        taggerdate: %(taggerdate)
        creator: %(creator) 
        creatordate: %(creatordate)
        subject: %(subject) 
        body: %(body) 
        contents: %(contents) 
        contents-subject: %(contents:subject) 
        contents-body: %(contents:body) 
        contents-signature: %(contents:signature) 
        upstream: %(upstream) 
        symref: %(symref) 
        flag: %(flag) 
        HEAD: %(HEAD) 
        color: %(color) 