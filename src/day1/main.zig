const std = @import("std");
const mem = std.mem;

fn parseLine(line: []const u8) u32 {
    var first: u8 = undefined;
    var second: u8 = undefined;

    for (line) |ch| {
        if (ch >= '0' and ch <= '9') {
            first = ch - '0';
            break;
        }
    }
    for (line) |ch| {
        if (ch >= '0' and ch <= '9') {
            second = ch - '0';
        }
    }

    return @as(u32, first) * 10 + second;
}

const Pattern = struct { pattern: []const u8, value: u32 };
const allPatterns = [_]Pattern{
    .{ .pattern = "1", .value = 1 },
    .{ .pattern = "2", .value = 2 },
    .{ .pattern = "3", .value = 3 },
    .{ .pattern = "4", .value = 4 },
    .{ .pattern = "5", .value = 5 },
    .{ .pattern = "6", .value = 6 },
    .{ .pattern = "7", .value = 7 },
    .{ .pattern = "8", .value = 8 },
    .{ .pattern = "9", .value = 9 },
    .{ .pattern = "one", .value = 1 },
    .{ .pattern = "two", .value = 2 },
    .{ .pattern = "three", .value = 3 },
    .{ .pattern = "four", .value = 4 },
    .{ .pattern = "five", .value = 5 },
    .{ .pattern = "six", .value = 6 },
    .{ .pattern = "seven", .value = 7 },
    .{ .pattern = "eight", .value = 8 },
    .{ .pattern = "nine", .value = 9 },
};

fn parseLine2(line: []const u8) u32 {
    var first: u32 = 0;
    var second: u32 = 0;

    for (line, 0..) |_, j| {
        for (allPatterns) |p| {
            if (mem.indexOf(u8, line[0 .. j + 1], p.pattern)) |_| {
                first = p.value;
                break;
            }
        }
        if (first != 0) break;
    }

    var j: usize = line.len - 1;
    while (j >= 0) {
        for (allPatterns) |p| {
            if (mem.indexOf(u8, line[j..], p.pattern)) |_| {
                second = p.value;
                break;
            }
        }
        if (second != 0) break;
        j -= 1;
    }
    return first * 10 + second;
}

pub fn calibration() !u32 {
    var f = try std.fs.cwd().openFile("./src/day1/data.txt", .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader());
    var stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var res: u32 = 0;
    while (try stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        res += parseLine2(line);
    }
    return res;
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Answer  : {}", .{try calibration()});

    try bw.flush(); // don't forget to flush!
}

test "single" {
    try std.testing.expectEqual(parseLine2("treb7uchet"), 77);
}

test "multiple" {
    try std.testing.expectEqual(parseLine2("a1b2c3d4e5f"), 15);
    try std.testing.expectEqual(parseLine2("pqr3stu8vwx"), 38);
}

test "v2 edge case" {
    try std.testing.expectEqual(parseLine2("eighthree"), 83);
    try std.testing.expectEqual(parseLine2("sevenine"), 79);
}
test "v2 normal case" {
    try std.testing.expectEqual(parseLine2("two1nine"), 29);
    try std.testing.expectEqual(parseLine2("eightwothree"), 83);
    try std.testing.expectEqual(parseLine2("abcone2threexyz"), 13);
    try std.testing.expectEqual(parseLine2("xtwone3four"), 24);
    try std.testing.expectEqual(parseLine2("4nineeightseven2"), 42);
    try std.testing.expectEqual(parseLine2("zoneight234"), 14);
    try std.testing.expectEqual(parseLine2("7pqrstsixteen"), 76);
}
