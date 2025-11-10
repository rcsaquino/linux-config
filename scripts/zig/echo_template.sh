#!/bin/bash
cat <<'EOF'
    // =====================[  SETUP ALLOCATOR  ]=====================
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    const alloc, const is_debug = switch (@import("builtin").mode) {
        .Debug, .ReleaseSafe => .{ debug_allocator.allocator(), true },
        .ReleaseFast, .ReleaseSmall => .{ std.heap.smp_allocator, false },
    };
    defer if (is_debug) {
        _ = debug_allocator.deinit();
    };
    // =========================[ END SETUP ]=========================
EOF
