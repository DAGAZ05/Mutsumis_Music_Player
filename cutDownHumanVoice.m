% 1.Function of this function
%     将音频数据去除人声
% 2.Input parameters
%     sampleDataInitial:原始数据，输入为列向量，2列（左右声道）
% 3.Output parameters
%     sampleData:去除人声效果后的数据
%     isSuccess:是否操作成功
% 4.Examples
%     [sampleData, isSuccess]=cutDownHumanVoice(sampleDataInitial);
% --------------Implementation goes here---------------------
% function [sampleData, isSuccess]=cutDownHumanVoice(sampleDataInitial)
%     if(size(sampleDataInitial, 2)==2) %双通道数据才进行操作
%         deta=sampleDataInitial(:, 1)-sampleDataInitial(:, 2); %两个通道的差值
%         sampleData(:, 1)=deta; %左通道赋值
%         sampleData(:, 2)=deta; %右通道赋值
%     else %单通道数据不进行操作
%         sampleData=sampleDataInitial;
%         isSuccess=false;
%     end
% end


% 加权混合：
% 使用参数 alpha 控制差值声道和原始声道的混合比例。
% alpha = 0.7 表示差值声道占 70%，原始声道占 30%。可以根据需要调整 alpha 的值。
% --------------Implementation goes here---------------------
% function [sampleData, isSuccess] = cutDownHumanVoice(sampleDataInitial)
%     % 1. 检查输入数据的有效性
%     if isempty(sampleDataInitial)
%         error('输入数据不能为空');
%     end
%     if ~isnumeric(sampleDataInitial)
%         error('输入数据必须是数值数组');
%     end
% 
%     % 2. 初始化输出
%     sampleData = sampleDataInitial;
%     isSuccess = true;
% 
%     % 3. 处理双通道数据
%     if size(sampleDataInitial, 2) == 2
%         % 计算左右声道的差值
%         deta = sampleDataInitial(:, 1) - sampleDataInitial(:, 2);
% 
%         % 加权混合原始声道和差值声道，保留部分立体声信息
%         alpha = 0.7; % 混合权重，可调整
%         sampleData(:, 1) = alpha * deta + (1 - alpha) * sampleDataInitial(:, 1);
%         sampleData(:, 2) = alpha * deta + (1 - alpha) * sampleDataInitial(:, 2);
%     else
%         % 4. 处理单通道数据
%         % 对单通道数据进行简单的滤波处理（可选）
%         sampleData = sampleDataInitial; % 直接返回原始数据
%         isSuccess = false; % 标记操作未成功
%     end
% end


% PCA 是一种降维技术，可以用于分离音频信号中的主要成分（如人声）和次要成分（如背景音乐）。
% 实现步骤：
% 将左右声道作为两个特征。
% 对音频信号进行 PCA，提取主成分。
% 去除第一个主成分（假设为人声），保留第二个主成分（假设为背景音乐）。
% --------------Implementation goes here---------------------
function [sampleData, isSuccess] = cutDownHumanVoice(sampleDataInitial)
    if size(sampleDataInitial, 2) ~= 2
        sampleData = sampleDataInitial;
        isSuccess = false;
        return;
    end

    % 1. 对左右声道进行 PCA
    [coeff, score, ~] = pca(sampleDataInitial);

    % 2. 去除第一个主成分（假设为人声）
    score(:, 1) = 0; % 将第一个主成分置零

    % 3. 重构信号
    sampleData = score * coeff';
    isSuccess = true;
end
