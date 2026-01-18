% 1.Function of this function
%     绕指定点旋转图片
% 2.Input parameters
%     center: 图片旋转中心（图片左上角为原点）
%     imageData: 原始图片数据
%     angle: 旋转角度
% 3.Output parameters
%     rotatedImage: 旋转后的图片数据
% 4.Examples
%     rotatedImage = rotateImageAroundPoint(~, [100,100], imageData, 30)
% --------------Implementation goes here---------------------
function rotatedImage = rotateImageAroundPoint(~, center, imageData, angle)
    % 获取图片尺寸
    [h, w, ~] = size(imageData);
    
    % 将旋转中心点平移到原点
    tx = -center(1);
    ty = -center(2);
    
    % 创建平移变换矩阵
    translateToOrigin = [1, 0, 0; 0, 1, 0; tx, ty, 1];
    
    % 创建旋转变换矩阵
    rotateMatrix = [cosd(angle), sind(angle), 0; -sind(angle), cosd(angle), 0; 0, 0, 1];
    
    % 创建平移回原始位置的变换矩阵
    translateBack = [1, 0, 0; 0, 1, 0; -tx, -ty, 1];
    
    % 组合变换：平移 -> 旋转 -> 平移回
    tform = affine2d(translateToOrigin * rotateMatrix * translateBack);
    
    % 对图片进行旋转
    rotatedImage = imwarp(imageData, tform, 'OutputView', imref2d([h, w]));
end
        