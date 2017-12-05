/**
 * 画像加工
 *
 * 画像をキャンパスへ描画する基本的な流れ
 * <ul>
 *     <li>img要素を作成(ノードには追加しない)
 *     <li>img要素に画像を読込
 *     <li>img要素をcanvasへ描画
 * </ul>
 *
 */
jQuery(function($) {

    var inputImg;
    var inputCanvas = $('<canvas>').appendTo($('#input-view')).get(0);
    var outputCanvas = $('<canvas>').appendTo($('#output-view')).get(0);
    var inputCxt = inputCanvas.getContext('2d');
    var outputCxt = outputCanvas.getContext('2d');

    var input;
    var output;

    // エラー表示
    function alert(text) {
        window.alert(text);
    }

    // img要素が存在すればtrue。存在しなければアラートを表示しfalseを返す。
    function checkImage () {
        if (($(inputImg).length  > 0) === false ) {
            alert('画像がありません。');
            return false;
        }
        return true;
    }

    // 読込画像タイプの確認
    // 適切な画像タイプならばtrue。対応していないタイプならばアラートを表示してfalseを返す
    function checkFileType(text) {
        // ファイルタイプの確認
        if (text.match(/^image\/(png|jpeg|gif)$/) === null) {
            alert('対応していないファイル形式です。\nファイルはPNG, JPEG, GIFに対応しています。');
            return false;
        }
        return true;
    }

    /*
     * 画像表示処理
     */
    // 画像読込ハンドラ
    function read(reader) {
        return function() {
            // imgへオブジェクトを読み込む
            inputImg = $('<img>').get(0);
            inputImg.onload = function() {
                try {
                    inputCanvas.width = inputImg.width;
                    inputCanvas.height = inputImg.height;
                    inputCxt.clearRect(0, 0, inputCanvas.width, inputCanvas.height);
                    inputCxt.drawImage(inputImg, 0, 0, inputImg.width, inputImg.height);
                } catch (e) {
                    alert('画像を開けませんでした。');
                }
            };
            inputImg.setAttribute('src', reader.result);
        };
    }

    // 参照ボタンを使う読込処理
    $('#upload').change (function() {
        var file, reader;

        // 選択したファイル情報
        file = this.files[0];

        // ファイルタイプの確認
        if (checkFileType(file.type) === false) {
            return false;
        }

        // canvasに描画
        reader = new FileReader();
        reader.onload = read(reader);
        reader.readAsDataURL(file);

    });

    /*
     * ドラッグアンドドロップの読込処理
     */
    $('#input-view').get(0).ondragover = function() {
        return false;
    };

    // bind('ondrop', function() {});はうまく動かなかった(2012.11.07)
    $('#input-view').get(0).ondrop = function(event) {

        var file, reader;

        if (event.dataTransfer.files.length === 0) {
            alert('画像を開けませんでした。');
            return false;
        }

        // ドロップされたファイル情報
        file = event.dataTransfer.files[0];

        // ファイルタイプの確認
        if (checkFileType(file.type) === false) {
            return false;
        }

        // canvasへの描画
        reader = new FileReader();
        reader.onload = read(reader);
        reader.readAsDataURL(file);

        // バブリング・デフォルト処理停止
        event.stopPropagation();
        event.preventDefault();

    };

    /*
     * 選択範囲用div要素表示
     */
    $('#select-img').click(function(event) {
        $('#rectangle').resizable();
        $('#rectangle').draggable();
        $('#rectangle').css({
            'display': 'block'
        });
        event.stopPropagation();
        event.preventDefault();
    });

    // 選択範囲用div要素をリサイズしたとき発生
    // triggerで呼び出すためbindを使う
    $('#rectangle').bind('resize', function(event) {
        $('#rect-width').val($(this).width());
        $('#rect-height').val($(this).height());
        event.stopPropagation();
        event.preventDefault();
    });

    // 横幅の固定値が入力
    $('#trim-width').keyup(function(event) {
        if ($(this).val() === '') {
            return false;
        }
        var width = parseInt($(this).val(), 10);
        if ((width > 0) === false) {
            alert('0より大きい整数を入力してください。');
            return false;
        }
        $('#rectangle').get(0).style.width = $(this).val() + 'px';
        $('#rectangle').trigger('resize');
        event.stopPropagation();
        event.preventDefault();
    });

    // 縦幅の固定値が入力
    $('#trim-height').keyup(function(event) {
        if ($(this).val() === '') {
            return false;
        }
        var height = parseInt($(this).val(), 10);
        if ((height > 0) === false) {
            alert('0より大きい整数を入力してください。');
            return false;
        }
        $('#rectangle').get(0).style.height = $(this).val() + 'px';
        $('#rectangle').trigger('resize');
        event.stopPropagation();
        event.preventDefault();
    });

    // triming
    $('#trimming').click(function(event) {
        var rect = {};
        var data;
        // rectangleの位置・サイズ取得
        rect.top= $('#rectangle').position().top;
        rect.left= $('#rectangle').position().left;
        rect.width = $('#rectangle').width();
        rect.height = $('#rectangle').height();
        $('#rectangle').css({
            'display': 'none'
        });
        // 選択範囲画像取得
        data = inputCxt.getImageData(rect.left, rect.top, rect.width, rect.height);
        // 画像出力
        outputCanvas.width = data.width;
        outputCanvas.height = data.height;
        outputCxt.putImageData(data, 0, 0);
    });

});
