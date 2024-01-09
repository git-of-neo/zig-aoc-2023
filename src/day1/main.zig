const std = @import("std");

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

pub fn calibration1() !u32 {
    var f = try std.fs.cwd().openFile("./src/day1/data.txt", .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader());
    var stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var res: u32 = 0;
    while (try stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        res += parseLine(line);
    }
    return res;
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Answer  : {}", .{try calibration1()});

    try bw.flush(); // don't forget to flush!
}

test "single" {
    try std.testing.expectEqual(parseLine("treb7uchet"), 77);
}

test "multiple" {
    try std.testing.expectEqual(parseLine("a1b2c3d4e5f"), 15);
    try std.testing.expectEqual(parseLine("pqr3stu8vwx"), 38);
}
