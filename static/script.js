Vue.use(VueMarkdown);
new Vue({
    el: '#app',
    data: {
        userMessage: "",
        talks: [],
        selectedTalkIndex: 0,
        receiving: false,
        selectedFile: null,
        selectedFileName: "",
        maxTalkCount: 10,
        textAreaRows: 1,
    },
    watch: {
        userMessage: function () {
            // 入力されているメッセージ内の改行コード数に応じて入力フォームの行数を設定する
            const match = this.userMessage.match(/\n/g);
            this.textAreaRows = match ? match.length + 1 : 1;
        },
        talks: {
            handler: function () {
                this.saveHistory();
            },
            deep: true
        },
    },
    computed: {
        selectedFileIconPath: function () {
            const splited = this.selectedFileName.split(".");
            return `images/${splited[splited.length - 1]}.svg`
        },
    },
    async mounted() {
        this.loadHistory();
        if (this.talks.length == 0)
            this.addTalk();
    },
    methods: {
        sendUserMessage: async function () {
            this.userMessage = this.userMessage.trim();
            if (this.receiving || !this.userMessage.length) return;
            this.talks[this.selectedTalkIndex].messages.push({
                content: this.userMessage,
                role: "user",
                selectedFileName: this.selectedFileName,
                selectedFileIconPath: this.selectedFileIconPath
            });
            await this.getCompletion(this.userMessage);
        },
        getCompletion: async function (message) {
            const talk = this.talks[this.selectedTalkIndex];
            talk.messages.push({ role: "assistant", content: "入力中..." });
            this.userMessage = "";
            this.receiving = true;
            this.textAreaRows = 1;

            let completion;
            if (this.selectedFile) {
                const params = new FormData();
                params.append("file", this.selectedFile);
                params.append("fileName", this.selectedFileName);
                params.append("message", message);
                const resp = await axios.post("/upload", params);
                completion = resp.data;
                this.selectedFile = null;
                this.selectedFileName = "";
            } else {
                const resp = await axios.post(`/conversation`, {
                    message: message,
                    history: talk.messages.slice(0, talk.messages.length - 2).map(m => { return { role: m.role, content: m.content }; })
                });
                completion = resp.data;
            }

            talk.messages[talk.messages.length - 1].content = completion;
            this.receiving = false;
        },
        selectTalk: function (index) {
            this.selectedTalkIndex = index;
        },
        addTalk: function () {
            const name = `チャット${this.talks.length + 1}`
            this.talks.push({ name: name, messages: [] });
            this.selectedTalkIndex = this.talks.length - 1;
            this.getCompletion("こんにちは");
        },
        deleteTalk: function (index) {
            this.selectedFile = null;
            this.selectedFileName = "";
            this.talks.splice(index, 1);
            this.selectedTalkIndex--;
            if (this.selectedTalkIndex < 0)
                this.selectedTalkIndex = 0;
            if (this.talks.length == 0)
                this.addTalk();
        },
        saveHistory: function () {
            localStorage.setItem("talks", JSON.stringify(this.talks));
        },
        loadHistory: function () {
            const talks = localStorage.getItem("talks");
            this.talks = talks ? JSON.parse(talks) : [];
        },
        selectFile: function () {
            document.getElementById("selectedFile").click();
        },
        onFileSelected: function (e) {
            if (e.target.files.length == 0) return;
            const file = e.target.files[0];
            this.selectedFile = file;
            this.selectedFileName = file.name;
            document.getElementById("selectedFile").value = "";
        }
    }
});
