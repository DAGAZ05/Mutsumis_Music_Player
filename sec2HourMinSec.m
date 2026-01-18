% 1.Function of this function
%     秒 变为 时：分：秒
% 2.Input parameters
%     tSecTotal:以秒表示的时间
% 3.Output parameters
%     tHourStr:时（两位字符串表示）
%     tMinStr:分（两位字符串表示）
%     tSecStr:秒（两位字符串表示）
% 4.Examples
%     Inputs:
%     tSecTotal=3670;
%     [tHourStr, tMinStr, tSecStr]=sec2HourMinSec(tSecTotal);
%     Results:
%     tHourStr='01'; tMinStr='01'; tSecStr='10';
% --------------Implementation goes here---------------------
function [tHourStr, tMinStr, tSecStr]=sec2HourMinSec(tSecTotal)
    tHour=floor(tSecTotal/3600); %取小时
    tSecTotalRemain=(tSecTotal-tHour*3600); %取完小时后，剩余的秒数
    tMin=floor(tSecTotalRemain/60); %取分钟
    tSecTotalRemain=(tSecTotalRemain-tMin*60); %取完分钟后，剩余的秒数
    tSec=floor(tSecTotalRemain); %取秒
    tHourStr=sprintf('%02d', tHour); %小时数转换成字符串输出
    tMinStr=sprintf('%02d', tMin); %分钟数转换成字符串输出
    tSecStr=sprintf('%02d', tSec); %秒数转换成字符串输出
end
