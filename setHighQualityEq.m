% 1.Function of this function
%     音频数据通过高级音效
% 2.Input parameters
%     sampleDataInitial:原始数据，输入为列向量，2列（左右声道）
%     EqType:Eq类型 'None''音乐厅''电音''交响乐''Live现场''HiFi环绕''合唱''镶边''相位''立体声拓展''回声'
%     fs:采样频率
% 3.Output parameters
%     sampleData: 使用音效函数后的音频数据
% 4.Examples
%     sampleData=setHighQualityEq(sampleDataInitial, '音乐厅', fs);
% --------------Implementation goes here---------------------
function sampleData = setHighQualityEq(sampleDataInitial, EqType, fs)
    switch EqType
        case 'None'
            sampleData = sampleDataInitial;
        case '音乐厅'
            sampleData = setConcertHallEffect(sampleDataInitial, fs);
        case '电音'
            sampleData = setElectronicEffect(sampleDataInitial, fs);
        case '交响乐'
            sampleData = setOrchestraEffect(sampleDataInitial, fs);
        case 'Live现场'
            sampleData = setLiveEffect(sampleDataInitial, fs);
        case 'HiFi环绕'
            sampleData = setHiFiEffect(sampleDataInitial, fs);
        case '合唱'
            sampleData = setChorusEffect(sampleDataInitial, fs);
        case '镶边'
            sampleData = setFlangerEffect(sampleDataInitial, fs);
        case '相位'
            sampleData = setPhaserEffect(sampleDataInitial, fs);
        case '立体声拓展'
            sampleData = setStereoWideningEffect(sampleDataInitial);
        case '回声'
            sampleData = setEchoEffect(sampleDataInitial, fs, 0.3, 0.5);
    end
end

% 1. 音乐厅音效
% 音乐厅音效的特点是具有丰富的混响和空间感。
% 实现方法：
% 均衡器调整：增强中低频（200 Hz - 1 kHz）和高频（8 kHz 以上）。
% 混响效果：添加长混响，模拟音乐厅的空间感。
function sampleData = setConcertHallEffect(sampleDataInitial, fs)
    % 1. 均衡器调整
    fre = [0 31 63 125 250 500 1000 2000 4000 8000 16000 fs/2]; % 12 个典型频率
    f = fre / (fs/2); % 归一化频率
    m = [0 1.259 1.585 1.995 2.512 1.995 1.585 1.259 1.585 1.995 2.512 0]; % 音乐厅 EQ
    b = fir2(100, f, m); % 获得 FIR 滤波器系数
    sampleData = filter(b, 1, sampleDataInitial); % 滤波

    % 2. 添加混响效果
    reverbTime = 0.8; % 混响时间（0 到 1 之间）
    sampleData = addReverb(sampleData, fs, reverbTime);
end

% 2. 电音音效
% 电音音效的特点是强烈的低频和清晰的高频。
% 实现方法：
% 均衡器调整：增强低频（60 Hz 以下）和高频（8 kHz 以上）。
% 失真效果：添加轻微的失真效果，模拟电子音乐的特点。
function sampleData = setElectronicEffect(sampleDataInitial, fs)
    % 1. 均衡器调整
    fre = [0 31 63 125 250 500 1000 2000 4000 8000 16000 fs/2]; % 12 个典型频率
    f = fre / (fs/2); % 归一化频率
    m = [0 3.981 2.512 1.585 1.259 1 1 1.259 1.585 2.512 3.981 0]; % 电音 EQ
    b = fir2(100, f, m); % 获得 FIR 滤波器系数
    sampleData = filter(b, 1, sampleDataInitial); % 滤波

    % 2. 添加失真效果
    sampleData = addDistortion(sampleData, 0.5); % 更强的失真效果

    % 3. 添加白噪声（模拟电流声）
    noiseIntensity = 0.01; % 噪声强度
    noise = noiseIntensity * randn(size(sampleData)); % 生成白噪声
    sampleData = sampleData + noise;

    % 4. 添加调制效果
    sampleData = addModulation(sampleData, fs);
end

% 3. 交响乐音效
% 交响乐音效的特点是平衡的频率响应和自然的空间感。
% 实现方法：
% 均衡器调整：保持频率响应平衡，略微增强中频（500 Hz - 2 kHz）。
% 混响效果：添加适度的混响，模拟音乐厅的环境。
function sampleData = setOrchestraEffect(sampleDataInitial, fs)
    % 1. 均衡器调整
    fre = [0 31 63 125 250 500 1000 2000 4000 8000 16000 fs/2]; % 12 个典型频率
    f = fre / (fs/2); % 归一化频率
    m = [0 1 1.259 1.585 1.995 2.512 1.995 1.585 1.259 1 1 0]; % 交响乐 EQ
    b = fir2(100, f, m); % 获得 FIR 滤波器系数
    sampleData = filter(b, 1, sampleDataInitial); % 滤波

    % 2. 添加混响效果
    reverbTime = 1.5; % 混响时间（秒）
    sampleData = addReverb(sampleData, fs, reverbTime);
end

% 4. Live 现场音效
% Live 现场音效的特点是强烈的低频和清晰的中高频。
% 实现方法：
% 均衡器调整：增强低频（60 Hz 以下）和中高频（2 kHz - 8 kHz）。
% 延迟效果：添加轻微的延迟，模拟现场演出的空间感。
function sampleData = setLiveEffect(sampleDataInitial, fs)
    % 1. 均衡器调整
    fre = [0 31 63 125 250 500 1000 2000 4000 8000 16000 fs/2]; % 12 个典型频率
    f = fre / (fs/2); % 归一化频率
    m = [0 3.162 2.512 1.995 1.585 1.259 1.585 1.995 2.512 3.162 2.512 0]; % Live EQ
    b = fir2(100, f, m); % 获得 FIR 滤波器系数
    sampleData = filter(b, 1, sampleDataInitial); % 滤波

    % 2. 添加延迟效果
    delayTime = 0.02; % 延迟时间（秒）
    sampleData = addDelay(sampleData, fs, delayTime);
end

% 5. HiFi 环绕音效
% HiFi 环绕音效的特点是宽广的声场和清晰的细节。
% 实现方法：
% 均衡器调整：保持频率响应平衡，略微增强高频（8 kHz 以上）。
% 立体声扩展：增强立体声效果，模拟环绕声场。
function sampleData = setHiFiEffect(sampleDataInitial, fs)
    % 1. 均衡器调整
    fre = [0 31 63 125 250 500 1000 2000 4000 8000 16000 fs/2]; % 12 个典型频率
    f = fre / (fs/2); % 归一化频率
    m = [0 1 1 1 1 1 1 1 1.259 1.585 2.512 0]; % HiFi EQ
    b = fir2(100, f, m); % 获得 FIR 滤波器系数
    sampleData = filter(b, 1, sampleDataInitial); % 滤波

    % 2. 添加立体声扩展效果
    sampleData = addStereoWidening(sampleData);
end

% 辅助函数
% 混响效果
function output = addReverb(input, fs, reverbTime)
    % 限制 reverbTime 在 0 到 1 之间
    reverbTime = min(max(reverbTime, 0), 1);

    % 使用 MATLAB 的 reverberator 函数添加混响
    reverb = reverberator('PreDelay', 0, 'WetDryMix', 0.8, 'SampleRate', fs, 'DecayFactor', reverbTime);
    output = reverb(input);
end

% 失真效果
function output = addDistortion(input, gain)
    % 更强的失真效果
    output = tanh(gain * input); % 使用双曲正切函数模拟失真
    output = output / max(abs(output(:))); % 归一化
end

% 延迟效果
function output = addDelay(input, fs, delayTime)
    % 添加延迟效果
    delaySamples = round(delayTime * fs); % 延迟的样本数
    output = [zeros(delaySamples, size(input, 2)); input(1:end-delaySamples, :)];
end

% % 立体声扩展
% function output = addStereoWidening(input)
%     % 简单的立体声扩展
%     output = [input(:, 1) * 1.5, input(:, 2) * 0.5];
% end

% 调制效果
function output = addModulation(input, fs)
    % 添加频率调制（FM）效果
    t = (0:length(input)-1)' / fs; % 时间向量
    modulator = sin(2 * pi * 5 * t); % 调制信号（5 Hz）
    output = input .* (1 + 0.5 * modulator); % 调制
end

% 其它音效
% 合唱
function sampleData = setChorusEffect(sampleDataInitial, fs)
    % 参数说明：
    % sampleDataInitial: 输入音频数据（双通道）
    % fs: 采样率

    % 1. 对左右声道分别处理
    leftChannel = sampleDataInitial(:, 1);
    rightChannel = sampleDataInitial(:, 2);

    % 2. 添加合唱效果
    leftChannelProcessed = addChorus(leftChannel, fs);
    rightChannelProcessed = addChorus(rightChannel, fs);

    % 3. 合并处理后的声道
    sampleData = [leftChannelProcessed, rightChannelProcessed];
end

function output = addChorus(input, fs)
    % 参数设置
    delay = 0.03; % 延迟时间（秒）
    depth = 0.005; % 调制深度
    rate = 0.5; % 调制频率（Hz）

    % 生成调制信号
    t = (0:length(input)-1)' / fs;
    modulator = depth * sin(2 * pi * rate * t);

    % 添加延迟和调制
    delayedSignal = [zeros(round(delay * fs), 1); input(1:end-round(delay * fs))];
    modulatedSignal = delayedSignal .* (1 + modulator);

    % 混合原始信号和处理后的信号
    output = input + modulatedSignal;
    output = output / max(abs(output)); % 归一化
end

% 镶边
function sampleData = setFlangerEffect(sampleDataInitial, fs)
    % 参数说明：
    % sampleDataInitial: 输入音频数据（双通道）
    % fs: 采样率

    % 1. 对左右声道分别处理
    leftChannel = sampleDataInitial(:, 1);
    rightChannel = sampleDataInitial(:, 2);

    % 2. 添加镶边效果
    leftChannelProcessed = addFlanger(leftChannel, fs);
    rightChannelProcessed = addFlanger(rightChannel, fs);

    % 3. 合并处理后的声道
    sampleData = [leftChannelProcessed, rightChannelProcessed];
end

function output = addFlanger(input, fs)
    % 参数设置
    delay = 0.01; % 基础延迟时间（秒）
    depth = 0.005; % 调制深度
    rate = 0.2; % 调制频率（Hz）

    % 生成调制信号
    t = (0:length(input)-1)' / fs;
    modulator = delay + depth * sin(2 * pi * rate * t);

    % 添加延迟和调制
    output = zeros(size(input));
    for i = 1:length(input)
        delaySamples = round(modulator(i) * fs);
        if i > delaySamples
            output(i) = input(i) + input(i - delaySamples);
        else
            output(i) = input(i);
        end
    end
    output = output / max(abs(output)); % 归一化
end

% 相位
function sampleData = setPhaserEffect(sampleDataInitial, fs)
    % 参数说明：
    % sampleDataInitial: 输入音频数据（双通道）
    % fs: 采样率

    % 1. 对左右声道分别处理
    leftChannel = sampleDataInitial(:, 1);
    rightChannel = sampleDataInitial(:, 2);

    % 2. 添加相位效果
    leftChannelProcessed = addPhaser(leftChannel, fs);
    rightChannelProcessed = addPhaser(rightChannel, fs);

    % 3. 合并处理后的声道
    sampleData = [leftChannelProcessed, rightChannelProcessed];
end

function output = addPhaser(input, fs)
    % 参数设置
    rate = 0.5; % 调制频率（Hz）
    depth = 4; % 全通滤波器数量

    % 生成调制信号
    t = (0:length(input)-1)' / fs;
    modulator = sin(2 * pi * rate * t);

    % 全通滤波器
    output = input;
    for i = 1:depth
        output = allpassFilter(output, fs, modulator);
    end
    output = (input + output) / 2; % 混合原始信号和处理后的信号
    output = output / max(abs(output)); % 归一化
end

function output = allpassFilter(input, fs, modulator)
    % 全通滤波器实现
    gain = 0.7; % 增益

    output = zeros(size(input));
    for i = 1:length(input)
        % 动态调整延迟时间
        delay = round(0.001 * fs * (1 + modulator(i))); % 延迟时间随 modulator 变化
        if i > delay
            output(i) = gain * input(i) + input(i - delay) - gain * output(i - delay);
        else
            output(i) = input(i);
        end
    end
end

% 立体声拓展
function sampleData = setStereoWideningEffect(sampleDataInitial)
    % 参数说明：
    % sampleDataInitial: 输入音频数据（双通道）

    % 1. 添加立体声扩展效果
    sampleData = addStereoWidening(sampleDataInitial);
end

function output = addStereoWidening(input)
    % 增强左右声道的差异
    output = [input(:, 1) * 1.5, input(:, 2) * 0.5];
    output = output / max(abs(output(:))); % 归一化
end

% 回声
function sampleData = setEchoEffect(sampleDataInitial, fs, delayTime, decay)
    % 参数说明：
    % sampleDataInitial: 输入音频数据（双通道）
    % fs: 采样率
    % delayTime: 延迟时间（秒）
    % decay: 衰减因子

    % 1. 对左右声道分别处理
    leftChannel = sampleDataInitial(:, 1);
    rightChannel = sampleDataInitial(:, 2);

    % 2. 添加回声效果
    leftChannelProcessed = addEcho(leftChannel, fs, delayTime, decay);
    rightChannelProcessed = addEcho(rightChannel, fs, delayTime, decay);

    % 3. 合并处理后的声道
    sampleData = [leftChannelProcessed, rightChannelProcessed];
end

function output = addEcho(input, fs, delayTime, decay)
    % 添加回声
    delaySamples = round(delayTime * fs);
    output = input;
    for i = delaySamples+1:length(input)
        output(i) = output(i) + decay * output(i - delaySamples);
    end
    output = output / max(abs(output)); % 归一化
end
