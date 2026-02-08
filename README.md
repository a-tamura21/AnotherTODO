AnotherTODO

I started this app a learning project using only functional programming languages. 
SoI decided to do what most people and build a to do app. But I decided to take it a step further.
Not only will the be built with only functional lanaguages(Elixir, Gleam, ReScript) but it compelely type safe.
I choose ELixir for the backend specifically for Beams which can be run on a virtual machine on Raspberry Pi and ESP32 devices which is helpful for my robotics projects.
The Frontend will rely on ReScript with React with Gleam in the middle to enforce type safety. 
The will provide AI generated summaries of tasks via API for several models. I decided to send prompts via API for costs reasons.
The backend provides complete user privacy with hashing and encryption to keep all stored information private.
For the database I'm currently using PostgreSQL as it's the one I'm most familiar with.
What still needs to be decided is what to do about animations for the frontend when using React with ReScript.
Also considering if I should dockerize the project or just make it deployable to AWS

このアプリは、関数型プログラミング言語のみを使った学習プロジェクトとして始めました。
そこで、多くの人と同じようにToDoアプリを作ることにしました。しかし、さらに一歩踏み込むことにしました。
このアプリは関数型言語（Elixir、Gleam、ReScript）のみで構築されるだけでなく、完全に型安全です。
バックエンドには、Raspberry PiとESP32デバイスの仮想マシンで実行できるBeam​​s専用のELixirを選択しました。これは、私のロボット工学プロジェクトに役立ちます。
フロントエンドは、型安全性を確保するために、ReScriptとReact、そしてGleamを中間に使用します。
複数のモデルについて、AIが生成したタスクの概要をAPI経由で提供します。コスト上の理由から、プロンプトはAPI経由で送信することにしました。
バックエンドは、ハッシュ化と暗号化によって完全なユーザープライバシーを提供し、保存されたすべての情報を非公開にします。
データベースについては、現在最も使い慣れているPostgreSQLを使用しています。
まだ決めなければならないのは、ReactとReScriptを使用する際にフロントエンドのアニメーションをどうするかということです。
また、プロジェクトをDocker化するべきか、それともAWSにデプロイできるようにするべきか検討中です。
