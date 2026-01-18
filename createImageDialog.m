% 1.Function of this function
%     根据输入图片文件创建对话框（主程序彩蛋surprise4）
% 2.Input parameters
%     imageFiles: 图片路径名数组
% 3.Output parameters
%     none
% 4.Examples
%     createImageDialog(app.imageFiles);
% --------------Implementation goes here---------------------
function createImageDialog(imageFiles)
    % 创建对话框
    d = uifigure('Name', '图片盲盒', 'Position', [487 227 400 400], 'AutoResizeChildren', 'off');

    % 添加网格布局
    g = uigridlayout(d, [3 1]);
    g.RowHeight = {'1x', 'fit', 'fit'}; % 第一行自适应，第二行和第三行固定高度
    g.ColumnWidth = {'1x'}; % 单列，宽度自适应

    % 添加图片组件
    img = uiimage(g);
    img.Layout.Row = 1;
    img.Layout.Column = 1;
    img.Tag = 'DialogImage'; % 设置 Tag 以便后续访问

    % 添加“选取”按钮
    pickButton = uibutton(g, 'push', 'Text', '选取');
    pickButton.Layout.Row = 2;
    pickButton.Layout.Column = 1;
    pickButton.ButtonPushedFcn = @(~, ~) pickRandomImage(imageFiles, img, d);

    % 添加“退出”按钮
    exitButton = uibutton(g, 'push', 'Text', '退出');
    exitButton.Layout.Row = 3;
    exitButton.Layout.Column = 1;
    exitButton.ButtonPushedFcn = @(~, ~) delete(d);

    % 监听对话框大小变化
    d.SizeChangedFcn = @(~, ~) resizeImage(img, d);
end

function pickRandomImage(imageFiles, img, d)
    % 随机选择一张图片
    if isempty(imageFiles)
        disp('文件夹中没有图片！');
        return;
    end

    % 随机选择一个文件
    randomIndex = randi(numel(imageFiles));
    selectedFile = fullfile(imageFiles(randomIndex).folder, imageFiles(randomIndex).name);

    % 显示图片
    img.ImageSource = selectedFile;

    % 调整图片大小
    resizeImage(img, d);
end

function resizeImage(img, d)
    % 获取对话框的当前大小
    dialogWidth = d.Position(3);
    dialogHeight = d.Position(4);

    % 设置图片组件的大小（通过调整布局的行高和列宽）
    img.Parent.RowHeight{1} = dialogHeight - 100; % 第一行高度自适应
    img.Parent.ColumnWidth{1} = dialogWidth - 20; % 第一列宽度自适应
end
