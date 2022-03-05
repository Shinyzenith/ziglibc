const builtin = @import("builtin");
const std = @import("std");

const c = struct {
    extern fn main(argc: c_int, argv: [*:null]?[*:0]u8) callconv(.C) c_int;
};

pub fn main() u8 {
    var argc: c_int = undefined;
    const args: [*:null]?[*:0]u8 = blk: {
        if (builtin.os.tag == .windows) {
            std.log.warn("command-line args not implemented on Windows!", .{});
            argc = 0;
            break :blk *[0:null]?[*:0]u8{};
        }
        argc = @intCast(c_int, std.os.argv.len);
        break :blk @ptrCast([*:null]?[*:0]u8, std.os.argv.ptr);
    };

    var result = c.main(argc, args);
    if (result != 0) {
        while ((result & 0xff == 0)) result = result >> 8;
    }
    return @intCast(u8, result & 0xff);
}
