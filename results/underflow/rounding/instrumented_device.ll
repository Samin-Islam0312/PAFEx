; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/rounding/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

@fp_invalid_counter = addrspace(1) global i64 0, align 8
@fp_divbyzero_counter = addrspace(1) global i64 0, align 8
@fp_overflow_counter = addrspace(1) global i64 0, align 8
@fp_underflow_counter = addrspace(1) global i64 0, align 8
@fp_total_counter = addrspace(1) global i64 0, align 8
@fp_subnormal_counter = addrspace(1) global i64 0, align 8

; Function Attrs: convergent noinline nounwind optnone
define dso_local noundef zeroext i1 @_Z12is_subnormalf(float noundef %x) #0 !dbg !963 {
entry:
  %__a.addr.i = alloca float, align 4
  %x.addr = alloca float, align 4
  store float %x, ptr %x.addr, align 4
    #dbg_declare(ptr %x.addr, !964, !DIExpression(), !965)
  %0 = load float, ptr %x.addr, align 4, !dbg !966
  %cmp = fcmp contract une float %0, 0.000000e+00, !dbg !967
  br i1 %cmp, label %land.rhs, label %land.end, !dbg !968

land.rhs:                                         ; preds = %entry
  %1 = load float, ptr %x.addr, align 4, !dbg !969
  store float %1, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !970, !DIExpression(), !971)
  %2 = load float, ptr %__a.addr.i, align 4, !dbg !973
  %3 = call float @llvm.nvvm.fabs.f32(float %2), !dbg !974
  %cmp1 = fcmp contract olt float %3, 0x3810000000000000, !dbg !975
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %4 = phi i1 [ false, %entry ], [ %cmp1, %land.rhs ], !dbg !976
  ret i1 %4, !dbg !977
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.f32(float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z26testUnderflow_RoundNearestPfPi(ptr noundef %result, ptr noundef %is_denormal) #2 !dbg !978 {
entry:
  %__a.addr.i50 = alloca float, align 4
  %__b.addr.i51 = alloca float, align 4
  %__c.addr.i = alloca float, align 4
  %__a.addr.i47 = alloca float, align 4
  %__b.addr.i48 = alloca float, align 4
  %__a.addr.i44 = alloca float, align 4
  %__b.addr.i45 = alloca float, align 4
  %__a.addr.i41 = alloca float, align 4
  %__b.addr.i42 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  %a = alloca float, align 4
  %b = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !981, !DIExpression(), !982)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !983, !DIExpression(), !984)
    #dbg_declare(ptr %idx, !985, !DIExpression(), !986)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !987
  store i32 %0, ptr %idx, align 4, !dbg !986
    #dbg_declare(ptr %tiny, !990, !DIExpression(), !991)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !991
  %1 = load i32, ptr %idx, align 4, !dbg !992
  %cmp = icmp eq i32 %1, 0, !dbg !994
  br i1 %cmp, label %if.then, label %if.end, !dbg !994

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !995
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !997, !DIExpression(), !1000)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1002, !DIExpression(), !1003)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1004
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1005
  %5 = bitcast float %3 to i32, !dbg !1006
  %6 = bitcast float %3 to i32, !dbg !1006
  %7 = and i32 %6, 2139095040, !dbg !1006
  %8 = icmp eq i32 %7, 2139095040, !dbg !1006
  %9 = and i32 %6, 8388607, !dbg !1006
  %10 = icmp ne i32 %9, 0, !dbg !1006
  %is_nan = and i1 %8, %10, !dbg !1006
  %11 = and i32 %5, 4194304, !dbg !1006
  %12 = icmp eq i32 %11, 0, !dbg !1006
  %is_snan = and i1 %is_nan, %12, !dbg !1006
  %13 = bitcast float %4 to i32, !dbg !1006
  %14 = bitcast float %4 to i32, !dbg !1006
  %15 = and i32 %14, 2139095040, !dbg !1006
  %16 = icmp eq i32 %15, 2139095040, !dbg !1006
  %17 = and i32 %14, 8388607, !dbg !1006
  %18 = icmp ne i32 %17, 0, !dbg !1006
  %is_nan1 = and i1 %16, %18, !dbg !1006
  %19 = and i32 %13, 4194304, !dbg !1006
  %20 = icmp eq i32 %19, 0, !dbg !1006
  %is_snan2 = and i1 %is_nan1, %20, !dbg !1006
  %21 = or i1 %is_snan, %is_snan2, !dbg !1006
  %22 = bitcast float %3 to i32, !dbg !1006
  %23 = and i32 %22, 2147483647, !dbg !1006
  %is_zero = icmp eq i32 %23, 0, !dbg !1006
  %24 = bitcast float %4 to i32, !dbg !1006
  %25 = and i32 %24, 2147483647, !dbg !1006
  %is_zero3 = icmp eq i32 %25, 0, !dbg !1006
  %26 = and i1 %is_zero, %is_zero3, !dbg !1006
  %27 = bitcast float %3 to i32, !dbg !1006
  %28 = and i32 %27, 2139095040, !dbg !1006
  %29 = icmp eq i32 %28, 2139095040, !dbg !1006
  %30 = and i32 %27, 8388607, !dbg !1006
  %31 = icmp eq i32 %30, 0, !dbg !1006
  %is_inf = and i1 %29, %31, !dbg !1006
  %32 = bitcast float %4 to i32, !dbg !1006
  %33 = and i32 %32, 2139095040, !dbg !1006
  %34 = icmp eq i32 %33, 2139095040, !dbg !1006
  %35 = and i32 %32, 8388607, !dbg !1006
  %36 = icmp eq i32 %35, 0, !dbg !1006
  %is_inf4 = and i1 %34, %36, !dbg !1006
  %37 = and i1 %is_inf, %is_inf4, !dbg !1006
  %38 = or i1 %26, %37, !dbg !1006
  %39 = or i1 %21, %38, !dbg !1006
  br i1 %39, label %40, label %42, !dbg !1006

40:                                               ; preds = %if.then
  %41 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1006
  br label %42, !dbg !1006

42:                                               ; preds = %if.then, %40
  %43 = bitcast float %4 to i32, !dbg !1006
  %44 = and i32 %43, 2147483647, !dbg !1006
  %is_zero5 = icmp eq i32 %44, 0, !dbg !1006
  %45 = bitcast float %3 to i32, !dbg !1006
  %46 = and i32 %45, 2139095040, !dbg !1006
  %is_finite = icmp ne i32 %46, 2139095040, !dbg !1006
  %47 = bitcast float %3 to i32, !dbg !1006
  %48 = and i32 %47, 2147483647, !dbg !1006
  %is_zero6 = icmp eq i32 %48, 0, !dbg !1006
  %49 = xor i1 %is_zero6, true, !dbg !1006
  %50 = and i1 %is_finite, %49, !dbg !1006
  %divzero_cond = and i1 %is_zero5, %50, !dbg !1006
  br i1 %divzero_cond, label %51, label %53, !dbg !1006

51:                                               ; preds = %42
  %52 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !1006
  br label %53, !dbg !1006

53:                                               ; preds = %42, %51
  %54 = call float @llvm.nvvm.div.rn.f(float %3, float %4), !dbg !1006
  %55 = bitcast float %3 to i32, !dbg !1007
  %56 = and i32 %55, 2139095040, !dbg !1007
  %is_finite7 = icmp ne i32 %56, 2139095040, !dbg !1007
  %57 = and i1 true, %is_finite7, !dbg !1007
  %58 = bitcast float %4 to i32, !dbg !1007
  %59 = and i32 %58, 2139095040, !dbg !1007
  %is_finite8 = icmp ne i32 %59, 2139095040, !dbg !1007
  %60 = and i1 %57, %is_finite8, !dbg !1007
  %61 = bitcast float %4 to i32, !dbg !1007
  %62 = and i32 %61, 2147483647, !dbg !1007
  %is_zero9 = icmp eq i32 %62, 0, !dbg !1007
  %63 = xor i1 %is_zero9, true, !dbg !1007
  %overflow_denom_nonzero = and i1 %60, %63, !dbg !1007
  %64 = bitcast float %54 to i32, !dbg !1007
  %65 = and i32 %64, 2139095040, !dbg !1007
  %66 = icmp eq i32 %65, 2139095040, !dbg !1007
  %67 = and i32 %64, 8388607, !dbg !1007
  %68 = icmp eq i32 %67, 0, !dbg !1007
  %is_inf10 = and i1 %66, %68, !dbg !1007
  %69 = bitcast float %54 to i32, !dbg !1007
  %70 = and i32 %69, 2147483647, !dbg !1007
  %is_maxfinite = icmp eq i32 %70, 2139095039, !dbg !1007
  %71 = bitcast float %54 to i32, !dbg !1007
  %72 = and i32 %71, -2147483648, !dbg !1007
  %73 = icmp eq i32 %72, 0, !dbg !1007
  %74 = icmp ne i32 %72, 0, !dbg !1007
  %is_pos_inf = and i1 %is_inf10, %73, !dbg !1007
  %is_neg_inf = and i1 %is_inf10, %74, !dbg !1007
  %is_pos_max = and i1 %is_maxfinite, %73, !dbg !1007
  %is_neg_max = and i1 %is_maxfinite, %74, !dbg !1007
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf10, !dbg !1007
  br i1 %overflow_cond, label %75, label %77, !dbg !1007

75:                                               ; preds = %53
  %76 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1007
  br label %77, !dbg !1007

77:                                               ; preds = %53, %75
  %78 = bitcast float %3 to i32, !dbg !1007
  %79 = and i32 %78, 2139095040, !dbg !1007
  %80 = icmp eq i32 %79, 0, !dbg !1007
  %81 = and i32 %78, 8388607, !dbg !1007
  %82 = icmp ne i32 %81, 0, !dbg !1007
  %is_subnormal = and i1 %80, %82, !dbg !1007
  %83 = xor i1 %is_subnormal, true, !dbg !1007
  %84 = and i1 true, %83, !dbg !1007
  %85 = bitcast float %4 to i32, !dbg !1007
  %86 = and i32 %85, 2139095040, !dbg !1007
  %87 = icmp eq i32 %86, 0, !dbg !1007
  %88 = and i32 %85, 8388607, !dbg !1007
  %89 = icmp ne i32 %88, 0, !dbg !1007
  %is_subnormal11 = and i1 %87, %89, !dbg !1007
  %90 = xor i1 %is_subnormal11, true, !dbg !1007
  %91 = and i1 %84, %90, !dbg !1007
  %92 = bitcast float %54 to i32, !dbg !1007
  %93 = and i32 %92, 2139095040, !dbg !1007
  %94 = icmp eq i32 %93, 0, !dbg !1007
  %95 = and i32 %92, 8388607, !dbg !1007
  %96 = icmp ne i32 %95, 0, !dbg !1007
  %is_subnormal12 = and i1 %94, %96, !dbg !1007
  %97 = bitcast float %54 to i32, !dbg !1007
  %98 = and i32 %97, 2147483647, !dbg !1007
  %is_zero13 = icmp eq i32 %98, 0, !dbg !1007
  %99 = bitcast float %3 to i32, !dbg !1007
  %100 = and i32 %99, 2147483647, !dbg !1007
  %is_zero14 = icmp eq i32 %100, 0, !dbg !1007
  %101 = xor i1 %is_zero14, true, !dbg !1007
  %102 = bitcast float %4 to i32, !dbg !1007
  %103 = and i32 %102, 2147483647, !dbg !1007
  %is_zero15 = icmp eq i32 %103, 0, !dbg !1007
  %104 = xor i1 %is_zero15, true, !dbg !1007
  %105 = and i1 %101, %104, !dbg !1007
  %106 = and i1 %is_zero13, %105, !dbg !1007
  %is_tiny = or i1 %is_subnormal12, %106, !dbg !1007
  %underflow_cond = and i1 %91, %is_tiny, !dbg !1007
  br i1 %underflow_cond, label %107, label %109, !dbg !1007

107:                                              ; preds = %77
  %108 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1007
  br label %109, !dbg !1007

109:                                              ; preds = %77, %107
  %110 = load ptr, ptr %result.addr, align 8, !dbg !1007
  %arrayidx = getelementptr inbounds float, ptr %110, i64 0, !dbg !1007
  store float %54, ptr %arrayidx, align 4, !dbg !1008
  %111 = load ptr, ptr %result.addr, align 8, !dbg !1009
  %arrayidx2 = getelementptr inbounds float, ptr %111, i64 0, !dbg !1009
  %112 = load float, ptr %arrayidx2, align 4, !dbg !1009
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %112) #4, !dbg !1010
  %113 = zext i1 %call3 to i64, !dbg !1010
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1010
  %114 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1011
  %arrayidx4 = getelementptr inbounds i32, ptr %114, i64 0, !dbg !1011
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1012
  br label %if.end, !dbg !1013

if.end:                                           ; preds = %109, %entry
  %115 = load i32, ptr %idx, align 4, !dbg !1014
  %cmp5 = icmp eq i32 %115, 1, !dbg !1016
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1016

if.then6:                                         ; preds = %if.end
  %116 = load float, ptr %tiny, align 4, !dbg !1017
  store float %116, ptr %__a.addr.i44, align 4
    #dbg_declare(ptr %__a.addr.i44, !1019, !DIExpression(), !1021)
  store float 5.000000e-01, ptr %__b.addr.i45, align 4
    #dbg_declare(ptr %__b.addr.i45, !1023, !DIExpression(), !1024)
  %117 = load float, ptr %__a.addr.i44, align 4, !dbg !1025
  %118 = load float, ptr %__b.addr.i45, align 4, !dbg !1026
  %119 = bitcast float %117 to i32, !dbg !1027
  %120 = bitcast float %117 to i32, !dbg !1027
  %121 = and i32 %120, 2139095040, !dbg !1027
  %122 = icmp eq i32 %121, 2139095040, !dbg !1027
  %123 = and i32 %120, 8388607, !dbg !1027
  %124 = icmp ne i32 %123, 0, !dbg !1027
  %is_nan16 = and i1 %122, %124, !dbg !1027
  %125 = and i32 %119, 4194304, !dbg !1027
  %126 = icmp eq i32 %125, 0, !dbg !1027
  %is_snan17 = and i1 %is_nan16, %126, !dbg !1027
  %127 = bitcast float %118 to i32, !dbg !1027
  %128 = bitcast float %118 to i32, !dbg !1027
  %129 = and i32 %128, 2139095040, !dbg !1027
  %130 = icmp eq i32 %129, 2139095040, !dbg !1027
  %131 = and i32 %128, 8388607, !dbg !1027
  %132 = icmp ne i32 %131, 0, !dbg !1027
  %is_nan18 = and i1 %130, %132, !dbg !1027
  %133 = and i32 %127, 4194304, !dbg !1027
  %134 = icmp eq i32 %133, 0, !dbg !1027
  %is_snan19 = and i1 %is_nan18, %134, !dbg !1027
  %135 = or i1 %is_snan17, %is_snan19, !dbg !1027
  %136 = bitcast float %117 to i32, !dbg !1027
  %137 = and i32 %136, 2147483647, !dbg !1027
  %is_zero20 = icmp eq i32 %137, 0, !dbg !1027
  %138 = bitcast float %118 to i32, !dbg !1027
  %139 = and i32 %138, 2139095040, !dbg !1027
  %140 = icmp eq i32 %139, 2139095040, !dbg !1027
  %141 = and i32 %138, 8388607, !dbg !1027
  %142 = icmp eq i32 %141, 0, !dbg !1027
  %is_inf21 = and i1 %140, %142, !dbg !1027
  %143 = and i1 %is_zero20, %is_inf21, !dbg !1027
  %144 = bitcast float %117 to i32, !dbg !1027
  %145 = and i32 %144, 2139095040, !dbg !1027
  %146 = icmp eq i32 %145, 2139095040, !dbg !1027
  %147 = and i32 %144, 8388607, !dbg !1027
  %148 = icmp eq i32 %147, 0, !dbg !1027
  %is_inf22 = and i1 %146, %148, !dbg !1027
  %149 = bitcast float %118 to i32, !dbg !1027
  %150 = and i32 %149, 2147483647, !dbg !1027
  %is_zero23 = icmp eq i32 %150, 0, !dbg !1027
  %151 = and i1 %is_inf22, %is_zero23, !dbg !1027
  %152 = or i1 %143, %151, !dbg !1027
  %153 = or i1 %135, %152, !dbg !1027
  br i1 %153, label %154, label %156, !dbg !1027

154:                                              ; preds = %if.then6
  %155 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1027
  br label %156, !dbg !1027

156:                                              ; preds = %if.then6, %154
  %157 = call float @llvm.nvvm.mul.rn.f(float %117, float %118), !dbg !1027
  %158 = bitcast float %117 to i32, !dbg !1028
  %159 = and i32 %158, 2139095040, !dbg !1028
  %is_finite24 = icmp ne i32 %159, 2139095040, !dbg !1028
  %160 = and i1 true, %is_finite24, !dbg !1028
  %161 = bitcast float %118 to i32, !dbg !1028
  %162 = and i32 %161, 2139095040, !dbg !1028
  %is_finite25 = icmp ne i32 %162, 2139095040, !dbg !1028
  %163 = and i1 %160, %is_finite25, !dbg !1028
  %164 = bitcast float %157 to i32, !dbg !1028
  %165 = and i32 %164, 2139095040, !dbg !1028
  %166 = icmp eq i32 %165, 2139095040, !dbg !1028
  %167 = and i32 %164, 8388607, !dbg !1028
  %168 = icmp eq i32 %167, 0, !dbg !1028
  %is_inf26 = and i1 %166, %168, !dbg !1028
  %169 = bitcast float %157 to i32, !dbg !1028
  %170 = and i32 %169, 2147483647, !dbg !1028
  %is_maxfinite27 = icmp eq i32 %170, 2139095039, !dbg !1028
  %171 = bitcast float %157 to i32, !dbg !1028
  %172 = and i32 %171, -2147483648, !dbg !1028
  %173 = icmp eq i32 %172, 0, !dbg !1028
  %174 = icmp ne i32 %172, 0, !dbg !1028
  %is_pos_inf28 = and i1 %is_inf26, %173, !dbg !1028
  %is_neg_inf29 = and i1 %is_inf26, %174, !dbg !1028
  %is_pos_max30 = and i1 %is_maxfinite27, %173, !dbg !1028
  %is_neg_max31 = and i1 %is_maxfinite27, %174, !dbg !1028
  %overflow_cond32 = and i1 %163, %is_inf26, !dbg !1028
  br i1 %overflow_cond32, label %175, label %177, !dbg !1028

175:                                              ; preds = %156
  %176 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1028
  br label %177, !dbg !1028

177:                                              ; preds = %156, %175
  %178 = bitcast float %117 to i32, !dbg !1028
  %179 = and i32 %178, 2139095040, !dbg !1028
  %180 = icmp eq i32 %179, 0, !dbg !1028
  %181 = and i32 %178, 8388607, !dbg !1028
  %182 = icmp ne i32 %181, 0, !dbg !1028
  %is_subnormal33 = and i1 %180, %182, !dbg !1028
  %183 = xor i1 %is_subnormal33, true, !dbg !1028
  %184 = and i1 true, %183, !dbg !1028
  %185 = bitcast float %118 to i32, !dbg !1028
  %186 = and i32 %185, 2139095040, !dbg !1028
  %187 = icmp eq i32 %186, 0, !dbg !1028
  %188 = and i32 %185, 8388607, !dbg !1028
  %189 = icmp ne i32 %188, 0, !dbg !1028
  %is_subnormal34 = and i1 %187, %189, !dbg !1028
  %190 = xor i1 %is_subnormal34, true, !dbg !1028
  %191 = and i1 %184, %190, !dbg !1028
  %192 = bitcast float %157 to i32, !dbg !1028
  %193 = and i32 %192, 2139095040, !dbg !1028
  %194 = icmp eq i32 %193, 0, !dbg !1028
  %195 = and i32 %192, 8388607, !dbg !1028
  %196 = icmp ne i32 %195, 0, !dbg !1028
  %is_subnormal35 = and i1 %194, %196, !dbg !1028
  %197 = bitcast float %157 to i32, !dbg !1028
  %198 = and i32 %197, 2147483647, !dbg !1028
  %is_zero36 = icmp eq i32 %198, 0, !dbg !1028
  %199 = bitcast float %117 to i32, !dbg !1028
  %200 = and i32 %199, 2147483647, !dbg !1028
  %is_zero37 = icmp eq i32 %200, 0, !dbg !1028
  %201 = xor i1 %is_zero37, true, !dbg !1028
  %202 = bitcast float %118 to i32, !dbg !1028
  %203 = and i32 %202, 2147483647, !dbg !1028
  %is_zero38 = icmp eq i32 %203, 0, !dbg !1028
  %204 = xor i1 %is_zero38, true, !dbg !1028
  %205 = and i1 %201, %204, !dbg !1028
  %206 = and i1 %is_zero36, %205, !dbg !1028
  %is_tiny39 = or i1 %is_subnormal35, %206, !dbg !1028
  %underflow_cond40 = and i1 %191, %is_tiny39, !dbg !1028
  br i1 %underflow_cond40, label %207, label %209, !dbg !1028

207:                                              ; preds = %177
  %208 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1028
  br label %209, !dbg !1028

209:                                              ; preds = %177, %207
  %210 = load ptr, ptr %result.addr, align 8, !dbg !1028
  %arrayidx8 = getelementptr inbounds float, ptr %210, i64 1, !dbg !1028
  store float %157, ptr %arrayidx8, align 4, !dbg !1029
  %211 = load ptr, ptr %result.addr, align 8, !dbg !1030
  %arrayidx9 = getelementptr inbounds float, ptr %211, i64 1, !dbg !1030
  %212 = load float, ptr %arrayidx9, align 4, !dbg !1030
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %212) #4, !dbg !1031
  %213 = zext i1 %call10 to i64, !dbg !1031
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1031
  %214 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1032
  %arrayidx12 = getelementptr inbounds i32, ptr %214, i64 1, !dbg !1032
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1033
  br label %if.end13, !dbg !1034

if.end13:                                         ; preds = %209, %if.end
  %215 = load i32, ptr %idx, align 4, !dbg !1035
  %cmp14 = icmp eq i32 %215, 2, !dbg !1037
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1037

if.then15:                                        ; preds = %if.end13
  %216 = load float, ptr %tiny, align 4, !dbg !1038
  store float %216, ptr %__a.addr.i41, align 4
    #dbg_declare(ptr %__a.addr.i41, !1019, !DIExpression(), !1040)
  store float 0x3BC79CA100000000, ptr %__b.addr.i42, align 4
    #dbg_declare(ptr %__b.addr.i42, !1023, !DIExpression(), !1042)
  %217 = load float, ptr %__a.addr.i41, align 4, !dbg !1043
  %218 = load float, ptr %__b.addr.i42, align 4, !dbg !1044
  %219 = bitcast float %217 to i32, !dbg !1045
  %220 = bitcast float %217 to i32, !dbg !1045
  %221 = and i32 %220, 2139095040, !dbg !1045
  %222 = icmp eq i32 %221, 2139095040, !dbg !1045
  %223 = and i32 %220, 8388607, !dbg !1045
  %224 = icmp ne i32 %223, 0, !dbg !1045
  %is_nan41 = and i1 %222, %224, !dbg !1045
  %225 = and i32 %219, 4194304, !dbg !1045
  %226 = icmp eq i32 %225, 0, !dbg !1045
  %is_snan42 = and i1 %is_nan41, %226, !dbg !1045
  %227 = bitcast float %218 to i32, !dbg !1045
  %228 = bitcast float %218 to i32, !dbg !1045
  %229 = and i32 %228, 2139095040, !dbg !1045
  %230 = icmp eq i32 %229, 2139095040, !dbg !1045
  %231 = and i32 %228, 8388607, !dbg !1045
  %232 = icmp ne i32 %231, 0, !dbg !1045
  %is_nan43 = and i1 %230, %232, !dbg !1045
  %233 = and i32 %227, 4194304, !dbg !1045
  %234 = icmp eq i32 %233, 0, !dbg !1045
  %is_snan44 = and i1 %is_nan43, %234, !dbg !1045
  %235 = or i1 %is_snan42, %is_snan44, !dbg !1045
  %236 = bitcast float %217 to i32, !dbg !1045
  %237 = and i32 %236, 2147483647, !dbg !1045
  %is_zero45 = icmp eq i32 %237, 0, !dbg !1045
  %238 = bitcast float %218 to i32, !dbg !1045
  %239 = and i32 %238, 2139095040, !dbg !1045
  %240 = icmp eq i32 %239, 2139095040, !dbg !1045
  %241 = and i32 %238, 8388607, !dbg !1045
  %242 = icmp eq i32 %241, 0, !dbg !1045
  %is_inf46 = and i1 %240, %242, !dbg !1045
  %243 = and i1 %is_zero45, %is_inf46, !dbg !1045
  %244 = bitcast float %217 to i32, !dbg !1045
  %245 = and i32 %244, 2139095040, !dbg !1045
  %246 = icmp eq i32 %245, 2139095040, !dbg !1045
  %247 = and i32 %244, 8388607, !dbg !1045
  %248 = icmp eq i32 %247, 0, !dbg !1045
  %is_inf47 = and i1 %246, %248, !dbg !1045
  %249 = bitcast float %218 to i32, !dbg !1045
  %250 = and i32 %249, 2147483647, !dbg !1045
  %is_zero48 = icmp eq i32 %250, 0, !dbg !1045
  %251 = and i1 %is_inf47, %is_zero48, !dbg !1045
  %252 = or i1 %243, %251, !dbg !1045
  %253 = or i1 %235, %252, !dbg !1045
  br i1 %253, label %254, label %256, !dbg !1045

254:                                              ; preds = %if.then15
  %255 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1045
  br label %256, !dbg !1045

256:                                              ; preds = %if.then15, %254
  %257 = call float @llvm.nvvm.mul.rn.f(float %217, float %218), !dbg !1045
  %258 = bitcast float %217 to i32, !dbg !1046
  %259 = and i32 %258, 2139095040, !dbg !1046
  %is_finite49 = icmp ne i32 %259, 2139095040, !dbg !1046
  %260 = and i1 true, %is_finite49, !dbg !1046
  %261 = bitcast float %218 to i32, !dbg !1046
  %262 = and i32 %261, 2139095040, !dbg !1046
  %is_finite50 = icmp ne i32 %262, 2139095040, !dbg !1046
  %263 = and i1 %260, %is_finite50, !dbg !1046
  %264 = bitcast float %257 to i32, !dbg !1046
  %265 = and i32 %264, 2139095040, !dbg !1046
  %266 = icmp eq i32 %265, 2139095040, !dbg !1046
  %267 = and i32 %264, 8388607, !dbg !1046
  %268 = icmp eq i32 %267, 0, !dbg !1046
  %is_inf51 = and i1 %266, %268, !dbg !1046
  %269 = bitcast float %257 to i32, !dbg !1046
  %270 = and i32 %269, 2147483647, !dbg !1046
  %is_maxfinite52 = icmp eq i32 %270, 2139095039, !dbg !1046
  %271 = bitcast float %257 to i32, !dbg !1046
  %272 = and i32 %271, -2147483648, !dbg !1046
  %273 = icmp eq i32 %272, 0, !dbg !1046
  %274 = icmp ne i32 %272, 0, !dbg !1046
  %is_pos_inf53 = and i1 %is_inf51, %273, !dbg !1046
  %is_neg_inf54 = and i1 %is_inf51, %274, !dbg !1046
  %is_pos_max55 = and i1 %is_maxfinite52, %273, !dbg !1046
  %is_neg_max56 = and i1 %is_maxfinite52, %274, !dbg !1046
  %overflow_cond57 = and i1 %263, %is_inf51, !dbg !1046
  br i1 %overflow_cond57, label %275, label %277, !dbg !1046

275:                                              ; preds = %256
  %276 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1046
  br label %277, !dbg !1046

277:                                              ; preds = %256, %275
  %278 = bitcast float %217 to i32, !dbg !1046
  %279 = and i32 %278, 2139095040, !dbg !1046
  %280 = icmp eq i32 %279, 0, !dbg !1046
  %281 = and i32 %278, 8388607, !dbg !1046
  %282 = icmp ne i32 %281, 0, !dbg !1046
  %is_subnormal58 = and i1 %280, %282, !dbg !1046
  %283 = xor i1 %is_subnormal58, true, !dbg !1046
  %284 = and i1 true, %283, !dbg !1046
  %285 = bitcast float %218 to i32, !dbg !1046
  %286 = and i32 %285, 2139095040, !dbg !1046
  %287 = icmp eq i32 %286, 0, !dbg !1046
  %288 = and i32 %285, 8388607, !dbg !1046
  %289 = icmp ne i32 %288, 0, !dbg !1046
  %is_subnormal59 = and i1 %287, %289, !dbg !1046
  %290 = xor i1 %is_subnormal59, true, !dbg !1046
  %291 = and i1 %284, %290, !dbg !1046
  %292 = bitcast float %257 to i32, !dbg !1046
  %293 = and i32 %292, 2139095040, !dbg !1046
  %294 = icmp eq i32 %293, 0, !dbg !1046
  %295 = and i32 %292, 8388607, !dbg !1046
  %296 = icmp ne i32 %295, 0, !dbg !1046
  %is_subnormal60 = and i1 %294, %296, !dbg !1046
  %297 = bitcast float %257 to i32, !dbg !1046
  %298 = and i32 %297, 2147483647, !dbg !1046
  %is_zero61 = icmp eq i32 %298, 0, !dbg !1046
  %299 = bitcast float %217 to i32, !dbg !1046
  %300 = and i32 %299, 2147483647, !dbg !1046
  %is_zero62 = icmp eq i32 %300, 0, !dbg !1046
  %301 = xor i1 %is_zero62, true, !dbg !1046
  %302 = bitcast float %218 to i32, !dbg !1046
  %303 = and i32 %302, 2147483647, !dbg !1046
  %is_zero63 = icmp eq i32 %303, 0, !dbg !1046
  %304 = xor i1 %is_zero63, true, !dbg !1046
  %305 = and i1 %301, %304, !dbg !1046
  %306 = and i1 %is_zero61, %305, !dbg !1046
  %is_tiny64 = or i1 %is_subnormal60, %306, !dbg !1046
  %underflow_cond65 = and i1 %291, %is_tiny64, !dbg !1046
  br i1 %underflow_cond65, label %307, label %309, !dbg !1046

307:                                              ; preds = %277
  %308 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1046
  br label %309, !dbg !1046

309:                                              ; preds = %277, %307
  %310 = load ptr, ptr %result.addr, align 8, !dbg !1046
  %arrayidx17 = getelementptr inbounds float, ptr %310, i64 2, !dbg !1046
  store float %257, ptr %arrayidx17, align 4, !dbg !1047
  %311 = load ptr, ptr %result.addr, align 8, !dbg !1048
  %arrayidx18 = getelementptr inbounds float, ptr %311, i64 2, !dbg !1048
  %312 = load float, ptr %arrayidx18, align 4, !dbg !1048
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %312) #4, !dbg !1049
  %313 = zext i1 %call19 to i64, !dbg !1049
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1049
  %314 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1050
  %arrayidx21 = getelementptr inbounds i32, ptr %314, i64 2, !dbg !1050
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1051
  br label %if.end22, !dbg !1052

if.end22:                                         ; preds = %309, %if.end13
  %315 = load i32, ptr %idx, align 4, !dbg !1053
  %cmp23 = icmp eq i32 %315, 3, !dbg !1055
  br i1 %cmp23, label %if.then24, label %if.end31, !dbg !1055

if.then24:                                        ; preds = %if.end22
    #dbg_declare(ptr %a, !1056, !DIExpression(), !1058)
  %316 = load float, ptr %tiny, align 4, !dbg !1059
  %317 = bitcast float %316 to i32, !dbg !1060
  %318 = bitcast float %316 to i32, !dbg !1060
  %319 = and i32 %318, 2139095040, !dbg !1060
  %320 = icmp eq i32 %319, 2139095040, !dbg !1060
  %321 = and i32 %318, 8388607, !dbg !1060
  %322 = icmp ne i32 %321, 0, !dbg !1060
  %is_nan66 = and i1 %320, %322, !dbg !1060
  %323 = and i32 %317, 4194304, !dbg !1060
  %324 = icmp eq i32 %323, 0, !dbg !1060
  %is_snan67 = and i1 %is_nan66, %324, !dbg !1060
  %325 = or i1 %is_snan67, false, !dbg !1060
  %326 = bitcast float %316 to i32, !dbg !1060
  %327 = and i32 %326, 2147483647, !dbg !1060
  %is_zero68 = icmp eq i32 %327, 0, !dbg !1060
  %328 = and i1 %is_zero68, false, !dbg !1060
  %329 = bitcast float %316 to i32, !dbg !1060
  %330 = and i32 %329, 2139095040, !dbg !1060
  %331 = icmp eq i32 %330, 2139095040, !dbg !1060
  %332 = and i32 %329, 8388607, !dbg !1060
  %333 = icmp eq i32 %332, 0, !dbg !1060
  %is_inf69 = and i1 %331, %333, !dbg !1060
  %334 = and i1 %is_inf69, false, !dbg !1060
  %335 = or i1 %328, %334, !dbg !1060
  %336 = or i1 %325, %335, !dbg !1060
  br i1 %336, label %337, label %339, !dbg !1060

337:                                              ; preds = %if.then24
  %338 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1060
  br label %339, !dbg !1060

339:                                              ; preds = %if.then24, %337
  %mul = fmul contract float %316, 0x3FF0000020000000, !dbg !1060
  %340 = bitcast float %316 to i32, !dbg !1058
  %341 = and i32 %340, 2139095040, !dbg !1058
  %is_finite70 = icmp ne i32 %341, 2139095040, !dbg !1058
  %342 = and i1 true, %is_finite70, !dbg !1058
  %343 = and i1 %342, true, !dbg !1058
  %344 = bitcast float %mul to i32, !dbg !1058
  %345 = and i32 %344, 2139095040, !dbg !1058
  %346 = icmp eq i32 %345, 2139095040, !dbg !1058
  %347 = and i32 %344, 8388607, !dbg !1058
  %348 = icmp eq i32 %347, 0, !dbg !1058
  %is_inf71 = and i1 %346, %348, !dbg !1058
  %349 = bitcast float %mul to i32, !dbg !1058
  %350 = and i32 %349, 2147483647, !dbg !1058
  %is_maxfinite72 = icmp eq i32 %350, 2139095039, !dbg !1058
  %351 = bitcast float %mul to i32, !dbg !1058
  %352 = and i32 %351, -2147483648, !dbg !1058
  %353 = icmp eq i32 %352, 0, !dbg !1058
  %354 = icmp ne i32 %352, 0, !dbg !1058
  %is_pos_inf73 = and i1 %is_inf71, %353, !dbg !1058
  %is_neg_inf74 = and i1 %is_inf71, %354, !dbg !1058
  %is_pos_max75 = and i1 %is_maxfinite72, %353, !dbg !1058
  %is_neg_max76 = and i1 %is_maxfinite72, %354, !dbg !1058
  %overflow_cond77 = and i1 %343, %is_inf71, !dbg !1058
  br i1 %overflow_cond77, label %355, label %357, !dbg !1058

355:                                              ; preds = %339
  %356 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1058
  br label %357, !dbg !1058

357:                                              ; preds = %339, %355
  %358 = bitcast float %316 to i32, !dbg !1058
  %359 = and i32 %358, 2139095040, !dbg !1058
  %360 = icmp eq i32 %359, 0, !dbg !1058
  %361 = and i32 %358, 8388607, !dbg !1058
  %362 = icmp ne i32 %361, 0, !dbg !1058
  %is_subnormal78 = and i1 %360, %362, !dbg !1058
  %363 = xor i1 %is_subnormal78, true, !dbg !1058
  %364 = and i1 true, %363, !dbg !1058
  %365 = and i1 %364, true, !dbg !1058
  %366 = bitcast float %mul to i32, !dbg !1058
  %367 = and i32 %366, 2139095040, !dbg !1058
  %368 = icmp eq i32 %367, 0, !dbg !1058
  %369 = and i32 %366, 8388607, !dbg !1058
  %370 = icmp ne i32 %369, 0, !dbg !1058
  %is_subnormal79 = and i1 %368, %370, !dbg !1058
  %371 = bitcast float %mul to i32, !dbg !1058
  %372 = and i32 %371, 2147483647, !dbg !1058
  %is_zero80 = icmp eq i32 %372, 0, !dbg !1058
  %373 = bitcast float %316 to i32, !dbg !1058
  %374 = and i32 %373, 2147483647, !dbg !1058
  %is_zero81 = icmp eq i32 %374, 0, !dbg !1058
  %375 = xor i1 %is_zero81, true, !dbg !1058
  %376 = and i1 %375, true, !dbg !1058
  %377 = and i1 %is_zero80, %376, !dbg !1058
  %is_tiny82 = or i1 %is_subnormal79, %377, !dbg !1058
  %underflow_cond83 = and i1 %365, %is_tiny82, !dbg !1058
  br i1 %underflow_cond83, label %378, label %380, !dbg !1058

378:                                              ; preds = %357
  %379 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1058
  br label %380, !dbg !1058

380:                                              ; preds = %357, %378
  store float %mul, ptr %a, align 4, !dbg !1058
    #dbg_declare(ptr %b, !1061, !DIExpression(), !1062)
  %381 = load float, ptr %tiny, align 4, !dbg !1063
  store float %381, ptr %b, align 4, !dbg !1062
  %382 = load float, ptr %a, align 4, !dbg !1064
  %383 = load float, ptr %b, align 4, !dbg !1065
  store float %382, ptr %__a.addr.i47, align 4
    #dbg_declare(ptr %__a.addr.i47, !1066, !DIExpression(), !1068)
  store float %383, ptr %__b.addr.i48, align 4
    #dbg_declare(ptr %__b.addr.i48, !1070, !DIExpression(), !1071)
  %384 = load float, ptr %__a.addr.i47, align 4, !dbg !1072
  %385 = load float, ptr %__b.addr.i48, align 4, !dbg !1073
  %386 = call float asm "sub.rn.f32 $0, $1, $2;", "=f,f,f"(float %384, float %385) #5, !dbg !1074, !srcloc !1075
  %387 = load ptr, ptr %result.addr, align 8, !dbg !1076
  %arrayidx26 = getelementptr inbounds float, ptr %387, i64 3, !dbg !1076
  store float %386, ptr %arrayidx26, align 4, !dbg !1077
  %388 = load ptr, ptr %result.addr, align 8, !dbg !1078
  %arrayidx27 = getelementptr inbounds float, ptr %388, i64 3, !dbg !1078
  %389 = load float, ptr %arrayidx27, align 4, !dbg !1078
  %call28 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %389) #4, !dbg !1079
  %390 = zext i1 %call28 to i64, !dbg !1079
  %cond29 = select i1 %call28, i32 1, i32 0, !dbg !1079
  %391 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1080
  %arrayidx30 = getelementptr inbounds i32, ptr %391, i64 3, !dbg !1080
  store i32 %cond29, ptr %arrayidx30, align 4, !dbg !1081
  br label %if.end31, !dbg !1082

if.end31:                                         ; preds = %380, %if.end22
  %392 = load i32, ptr %idx, align 4, !dbg !1083
  %cmp32 = icmp eq i32 %392, 4, !dbg !1085
  br i1 %cmp32, label %if.then33, label %if.end40, !dbg !1085

if.then33:                                        ; preds = %if.end31
  %393 = load float, ptr %tiny, align 4, !dbg !1086
  store float %393, ptr %__a.addr.i50, align 4
    #dbg_declare(ptr %__a.addr.i50, !1088, !DIExpression(), !1090)
  store float 2.500000e-01, ptr %__b.addr.i51, align 4
    #dbg_declare(ptr %__b.addr.i51, !1092, !DIExpression(), !1093)
  store float 0.000000e+00, ptr %__c.addr.i, align 4
    #dbg_declare(ptr %__c.addr.i, !1094, !DIExpression(), !1095)
  %394 = load float, ptr %__a.addr.i50, align 4, !dbg !1096
  %395 = load float, ptr %__b.addr.i51, align 4, !dbg !1097
  %396 = load float, ptr %__c.addr.i, align 4, !dbg !1098
  %397 = bitcast float %394 to i32, !dbg !1099
  %398 = bitcast float %394 to i32, !dbg !1099
  %399 = and i32 %398, 2139095040, !dbg !1099
  %400 = icmp eq i32 %399, 2139095040, !dbg !1099
  %401 = and i32 %398, 8388607, !dbg !1099
  %402 = icmp ne i32 %401, 0, !dbg !1099
  %is_nan84 = and i1 %400, %402, !dbg !1099
  %403 = and i32 %397, 4194304, !dbg !1099
  %404 = icmp eq i32 %403, 0, !dbg !1099
  %is_snan85 = and i1 %is_nan84, %404, !dbg !1099
  %405 = bitcast float %395 to i32, !dbg !1099
  %406 = bitcast float %395 to i32, !dbg !1099
  %407 = and i32 %406, 2139095040, !dbg !1099
  %408 = icmp eq i32 %407, 2139095040, !dbg !1099
  %409 = and i32 %406, 8388607, !dbg !1099
  %410 = icmp ne i32 %409, 0, !dbg !1099
  %is_nan86 = and i1 %408, %410, !dbg !1099
  %411 = and i32 %405, 4194304, !dbg !1099
  %412 = icmp eq i32 %411, 0, !dbg !1099
  %is_snan87 = and i1 %is_nan86, %412, !dbg !1099
  %413 = or i1 %is_snan85, %is_snan87, !dbg !1099
  %414 = bitcast float %396 to i32, !dbg !1099
  %415 = bitcast float %396 to i32, !dbg !1099
  %416 = and i32 %415, 2139095040, !dbg !1099
  %417 = icmp eq i32 %416, 2139095040, !dbg !1099
  %418 = and i32 %415, 8388607, !dbg !1099
  %419 = icmp ne i32 %418, 0, !dbg !1099
  %is_nan88 = and i1 %417, %419, !dbg !1099
  %420 = and i32 %414, 4194304, !dbg !1099
  %421 = icmp eq i32 %420, 0, !dbg !1099
  %is_snan89 = and i1 %is_nan88, %421, !dbg !1099
  %422 = or i1 %413, %is_snan89, !dbg !1099
  %423 = bitcast float %394 to i32, !dbg !1099
  %424 = and i32 %423, 2147483647, !dbg !1099
  %is_zero90 = icmp eq i32 %424, 0, !dbg !1099
  %425 = bitcast float %395 to i32, !dbg !1099
  %426 = and i32 %425, 2139095040, !dbg !1099
  %427 = icmp eq i32 %426, 2139095040, !dbg !1099
  %428 = and i32 %425, 8388607, !dbg !1099
  %429 = icmp eq i32 %428, 0, !dbg !1099
  %is_inf91 = and i1 %427, %429, !dbg !1099
  %430 = and i1 %is_zero90, %is_inf91, !dbg !1099
  %431 = bitcast float %394 to i32, !dbg !1099
  %432 = and i32 %431, 2139095040, !dbg !1099
  %433 = icmp eq i32 %432, 2139095040, !dbg !1099
  %434 = and i32 %431, 8388607, !dbg !1099
  %435 = icmp eq i32 %434, 0, !dbg !1099
  %is_inf92 = and i1 %433, %435, !dbg !1099
  %436 = bitcast float %395 to i32, !dbg !1099
  %437 = and i32 %436, 2147483647, !dbg !1099
  %is_zero93 = icmp eq i32 %437, 0, !dbg !1099
  %438 = and i1 %is_inf92, %is_zero93, !dbg !1099
  %439 = or i1 %430, %438, !dbg !1099
  %440 = or i1 %422, %439, !dbg !1099
  br i1 %440, label %441, label %443, !dbg !1099

441:                                              ; preds = %if.then33
  %442 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1099
  br label %443, !dbg !1099

443:                                              ; preds = %if.then33, %441
  %444 = call float @llvm.nvvm.fma.rn.f(float %394, float %395, float %396), !dbg !1099
  %445 = bitcast float %394 to i32, !dbg !1100
  %446 = and i32 %445, 2139095040, !dbg !1100
  %is_finite94 = icmp ne i32 %446, 2139095040, !dbg !1100
  %447 = and i1 true, %is_finite94, !dbg !1100
  %448 = bitcast float %395 to i32, !dbg !1100
  %449 = and i32 %448, 2139095040, !dbg !1100
  %is_finite95 = icmp ne i32 %449, 2139095040, !dbg !1100
  %450 = and i1 %447, %is_finite95, !dbg !1100
  %451 = bitcast float %444 to i32, !dbg !1100
  %452 = and i32 %451, 2139095040, !dbg !1100
  %453 = icmp eq i32 %452, 2139095040, !dbg !1100
  %454 = and i32 %451, 8388607, !dbg !1100
  %455 = icmp eq i32 %454, 0, !dbg !1100
  %is_inf96 = and i1 %453, %455, !dbg !1100
  %456 = bitcast float %444 to i32, !dbg !1100
  %457 = and i32 %456, 2147483647, !dbg !1100
  %is_maxfinite97 = icmp eq i32 %457, 2139095039, !dbg !1100
  %458 = bitcast float %444 to i32, !dbg !1100
  %459 = and i32 %458, -2147483648, !dbg !1100
  %460 = icmp eq i32 %459, 0, !dbg !1100
  %461 = icmp ne i32 %459, 0, !dbg !1100
  %is_pos_inf98 = and i1 %is_inf96, %460, !dbg !1100
  %is_neg_inf99 = and i1 %is_inf96, %461, !dbg !1100
  %is_pos_max100 = and i1 %is_maxfinite97, %460, !dbg !1100
  %is_neg_max101 = and i1 %is_maxfinite97, %461, !dbg !1100
  %overflow_cond102 = and i1 %450, %is_inf96, !dbg !1100
  br i1 %overflow_cond102, label %462, label %464, !dbg !1100

462:                                              ; preds = %443
  %463 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1100
  br label %464, !dbg !1100

464:                                              ; preds = %443, %462
  %465 = bitcast float %394 to i32, !dbg !1100
  %466 = and i32 %465, 2139095040, !dbg !1100
  %467 = icmp eq i32 %466, 0, !dbg !1100
  %468 = and i32 %465, 8388607, !dbg !1100
  %469 = icmp ne i32 %468, 0, !dbg !1100
  %is_subnormal103 = and i1 %467, %469, !dbg !1100
  %470 = xor i1 %is_subnormal103, true, !dbg !1100
  %471 = and i1 true, %470, !dbg !1100
  %472 = bitcast float %395 to i32, !dbg !1100
  %473 = and i32 %472, 2139095040, !dbg !1100
  %474 = icmp eq i32 %473, 0, !dbg !1100
  %475 = and i32 %472, 8388607, !dbg !1100
  %476 = icmp ne i32 %475, 0, !dbg !1100
  %is_subnormal104 = and i1 %474, %476, !dbg !1100
  %477 = xor i1 %is_subnormal104, true, !dbg !1100
  %478 = and i1 %471, %477, !dbg !1100
  %479 = bitcast float %396 to i32, !dbg !1100
  %480 = and i32 %479, 2139095040, !dbg !1100
  %481 = icmp eq i32 %480, 0, !dbg !1100
  %482 = and i32 %479, 8388607, !dbg !1100
  %483 = icmp ne i32 %482, 0, !dbg !1100
  %is_subnormal105 = and i1 %481, %483, !dbg !1100
  %484 = xor i1 %is_subnormal105, true, !dbg !1100
  %485 = and i1 %478, %484, !dbg !1100
  %486 = bitcast float %444 to i32, !dbg !1100
  %487 = and i32 %486, 2139095040, !dbg !1100
  %488 = icmp eq i32 %487, 0, !dbg !1100
  %489 = and i32 %486, 8388607, !dbg !1100
  %490 = icmp ne i32 %489, 0, !dbg !1100
  %is_subnormal106 = and i1 %488, %490, !dbg !1100
  %is_tiny107 = or i1 %is_subnormal106, false, !dbg !1100
  %underflow_cond108 = and i1 %485, %is_tiny107, !dbg !1100
  br i1 %underflow_cond108, label %491, label %493, !dbg !1100

491:                                              ; preds = %464
  %492 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1100
  br label %493, !dbg !1100

493:                                              ; preds = %464, %491
  %494 = load ptr, ptr %result.addr, align 8, !dbg !1100
  %arrayidx35 = getelementptr inbounds float, ptr %494, i64 4, !dbg !1100
  store float %444, ptr %arrayidx35, align 4, !dbg !1101
  %495 = load ptr, ptr %result.addr, align 8, !dbg !1102
  %arrayidx36 = getelementptr inbounds float, ptr %495, i64 4, !dbg !1102
  %496 = load float, ptr %arrayidx36, align 4, !dbg !1102
  %call37 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %496) #4, !dbg !1103
  %497 = zext i1 %call37 to i64, !dbg !1103
  %cond38 = select i1 %call37, i32 1, i32 0, !dbg !1103
  %498 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1104
  %arrayidx39 = getelementptr inbounds i32, ptr %498, i64 4, !dbg !1104
  store i32 %cond38, ptr %arrayidx39, align 4, !dbg !1105
  br label %if.end40, !dbg !1106

if.end40:                                         ; preds = %493, %if.end31
  ret void, !dbg !1107
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rn.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.f(float, float, float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z23testUnderflow_RoundZeroPfPi(ptr noundef %result, ptr noundef %is_denormal) #2 !dbg !1108 {
entry:
  %__a.addr.i26 = alloca float, align 4
  %__b.addr.i27 = alloca float, align 4
  %__a.addr.i23 = alloca float, align 4
  %__b.addr.i24 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1109, !DIExpression(), !1110)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1111, !DIExpression(), !1112)
    #dbg_declare(ptr %idx, !1113, !DIExpression(), !1114)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1115
  store i32 %0, ptr %idx, align 4, !dbg !1114
    #dbg_declare(ptr %tiny, !1117, !DIExpression(), !1118)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1118
  %1 = load i32, ptr %idx, align 4, !dbg !1119
  %cmp = icmp eq i32 %1, 0, !dbg !1121
  br i1 %cmp, label %if.then, label %if.end, !dbg !1121

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1122
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1124, !DIExpression(), !1126)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1128, !DIExpression(), !1129)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1130
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1131
  %5 = bitcast float %3 to i32, !dbg !1132
  %6 = bitcast float %3 to i32, !dbg !1132
  %7 = and i32 %6, 2139095040, !dbg !1132
  %8 = icmp eq i32 %7, 2139095040, !dbg !1132
  %9 = and i32 %6, 8388607, !dbg !1132
  %10 = icmp ne i32 %9, 0, !dbg !1132
  %is_nan = and i1 %8, %10, !dbg !1132
  %11 = and i32 %5, 4194304, !dbg !1132
  %12 = icmp eq i32 %11, 0, !dbg !1132
  %is_snan = and i1 %is_nan, %12, !dbg !1132
  %13 = bitcast float %4 to i32, !dbg !1132
  %14 = bitcast float %4 to i32, !dbg !1132
  %15 = and i32 %14, 2139095040, !dbg !1132
  %16 = icmp eq i32 %15, 2139095040, !dbg !1132
  %17 = and i32 %14, 8388607, !dbg !1132
  %18 = icmp ne i32 %17, 0, !dbg !1132
  %is_nan1 = and i1 %16, %18, !dbg !1132
  %19 = and i32 %13, 4194304, !dbg !1132
  %20 = icmp eq i32 %19, 0, !dbg !1132
  %is_snan2 = and i1 %is_nan1, %20, !dbg !1132
  %21 = or i1 %is_snan, %is_snan2, !dbg !1132
  %22 = bitcast float %3 to i32, !dbg !1132
  %23 = and i32 %22, 2147483647, !dbg !1132
  %is_zero = icmp eq i32 %23, 0, !dbg !1132
  %24 = bitcast float %4 to i32, !dbg !1132
  %25 = and i32 %24, 2147483647, !dbg !1132
  %is_zero3 = icmp eq i32 %25, 0, !dbg !1132
  %26 = and i1 %is_zero, %is_zero3, !dbg !1132
  %27 = bitcast float %3 to i32, !dbg !1132
  %28 = and i32 %27, 2139095040, !dbg !1132
  %29 = icmp eq i32 %28, 2139095040, !dbg !1132
  %30 = and i32 %27, 8388607, !dbg !1132
  %31 = icmp eq i32 %30, 0, !dbg !1132
  %is_inf = and i1 %29, %31, !dbg !1132
  %32 = bitcast float %4 to i32, !dbg !1132
  %33 = and i32 %32, 2139095040, !dbg !1132
  %34 = icmp eq i32 %33, 2139095040, !dbg !1132
  %35 = and i32 %32, 8388607, !dbg !1132
  %36 = icmp eq i32 %35, 0, !dbg !1132
  %is_inf4 = and i1 %34, %36, !dbg !1132
  %37 = and i1 %is_inf, %is_inf4, !dbg !1132
  %38 = or i1 %26, %37, !dbg !1132
  %39 = or i1 %21, %38, !dbg !1132
  br i1 %39, label %40, label %42, !dbg !1132

40:                                               ; preds = %if.then
  %41 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1132
  br label %42, !dbg !1132

42:                                               ; preds = %if.then, %40
  %43 = bitcast float %4 to i32, !dbg !1132
  %44 = and i32 %43, 2147483647, !dbg !1132
  %is_zero5 = icmp eq i32 %44, 0, !dbg !1132
  %45 = bitcast float %3 to i32, !dbg !1132
  %46 = and i32 %45, 2139095040, !dbg !1132
  %is_finite = icmp ne i32 %46, 2139095040, !dbg !1132
  %47 = bitcast float %3 to i32, !dbg !1132
  %48 = and i32 %47, 2147483647, !dbg !1132
  %is_zero6 = icmp eq i32 %48, 0, !dbg !1132
  %49 = xor i1 %is_zero6, true, !dbg !1132
  %50 = and i1 %is_finite, %49, !dbg !1132
  %divzero_cond = and i1 %is_zero5, %50, !dbg !1132
  br i1 %divzero_cond, label %51, label %53, !dbg !1132

51:                                               ; preds = %42
  %52 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !1132
  br label %53, !dbg !1132

53:                                               ; preds = %42, %51
  %54 = call float @llvm.nvvm.div.rz.f(float %3, float %4), !dbg !1132
  %55 = bitcast float %3 to i32, !dbg !1133
  %56 = and i32 %55, 2139095040, !dbg !1133
  %is_finite7 = icmp ne i32 %56, 2139095040, !dbg !1133
  %57 = and i1 true, %is_finite7, !dbg !1133
  %58 = bitcast float %4 to i32, !dbg !1133
  %59 = and i32 %58, 2139095040, !dbg !1133
  %is_finite8 = icmp ne i32 %59, 2139095040, !dbg !1133
  %60 = and i1 %57, %is_finite8, !dbg !1133
  %61 = bitcast float %4 to i32, !dbg !1133
  %62 = and i32 %61, 2147483647, !dbg !1133
  %is_zero9 = icmp eq i32 %62, 0, !dbg !1133
  %63 = xor i1 %is_zero9, true, !dbg !1133
  %overflow_denom_nonzero = and i1 %60, %63, !dbg !1133
  %64 = bitcast float %54 to i32, !dbg !1133
  %65 = and i32 %64, 2139095040, !dbg !1133
  %66 = icmp eq i32 %65, 2139095040, !dbg !1133
  %67 = and i32 %64, 8388607, !dbg !1133
  %68 = icmp eq i32 %67, 0, !dbg !1133
  %is_inf10 = and i1 %66, %68, !dbg !1133
  %69 = bitcast float %54 to i32, !dbg !1133
  %70 = and i32 %69, 2147483647, !dbg !1133
  %is_maxfinite = icmp eq i32 %70, 2139095039, !dbg !1133
  %71 = bitcast float %54 to i32, !dbg !1133
  %72 = and i32 %71, -2147483648, !dbg !1133
  %73 = icmp eq i32 %72, 0, !dbg !1133
  %74 = icmp ne i32 %72, 0, !dbg !1133
  %is_pos_inf = and i1 %is_inf10, %73, !dbg !1133
  %is_neg_inf = and i1 %is_inf10, %74, !dbg !1133
  %is_pos_max = and i1 %is_maxfinite, %73, !dbg !1133
  %is_neg_max = and i1 %is_maxfinite, %74, !dbg !1133
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_maxfinite, !dbg !1133
  br i1 %overflow_cond, label %75, label %77, !dbg !1133

75:                                               ; preds = %53
  %76 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1133
  br label %77, !dbg !1133

77:                                               ; preds = %53, %75
  %78 = bitcast float %3 to i32, !dbg !1133
  %79 = and i32 %78, 2139095040, !dbg !1133
  %80 = icmp eq i32 %79, 0, !dbg !1133
  %81 = and i32 %78, 8388607, !dbg !1133
  %82 = icmp ne i32 %81, 0, !dbg !1133
  %is_subnormal = and i1 %80, %82, !dbg !1133
  %83 = xor i1 %is_subnormal, true, !dbg !1133
  %84 = and i1 true, %83, !dbg !1133
  %85 = bitcast float %4 to i32, !dbg !1133
  %86 = and i32 %85, 2139095040, !dbg !1133
  %87 = icmp eq i32 %86, 0, !dbg !1133
  %88 = and i32 %85, 8388607, !dbg !1133
  %89 = icmp ne i32 %88, 0, !dbg !1133
  %is_subnormal11 = and i1 %87, %89, !dbg !1133
  %90 = xor i1 %is_subnormal11, true, !dbg !1133
  %91 = and i1 %84, %90, !dbg !1133
  %92 = bitcast float %54 to i32, !dbg !1133
  %93 = and i32 %92, 2139095040, !dbg !1133
  %94 = icmp eq i32 %93, 0, !dbg !1133
  %95 = and i32 %92, 8388607, !dbg !1133
  %96 = icmp ne i32 %95, 0, !dbg !1133
  %is_subnormal12 = and i1 %94, %96, !dbg !1133
  %97 = bitcast float %54 to i32, !dbg !1133
  %98 = and i32 %97, 2147483647, !dbg !1133
  %is_zero13 = icmp eq i32 %98, 0, !dbg !1133
  %99 = bitcast float %3 to i32, !dbg !1133
  %100 = and i32 %99, 2147483647, !dbg !1133
  %is_zero14 = icmp eq i32 %100, 0, !dbg !1133
  %101 = xor i1 %is_zero14, true, !dbg !1133
  %102 = bitcast float %4 to i32, !dbg !1133
  %103 = and i32 %102, 2147483647, !dbg !1133
  %is_zero15 = icmp eq i32 %103, 0, !dbg !1133
  %104 = xor i1 %is_zero15, true, !dbg !1133
  %105 = and i1 %101, %104, !dbg !1133
  %106 = and i1 %is_zero13, %105, !dbg !1133
  %is_tiny = or i1 %is_subnormal12, %106, !dbg !1133
  %underflow_cond = and i1 %91, %is_tiny, !dbg !1133
  br i1 %underflow_cond, label %107, label %109, !dbg !1133

107:                                              ; preds = %77
  %108 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1133
  br label %109, !dbg !1133

109:                                              ; preds = %77, %107
  %110 = load ptr, ptr %result.addr, align 8, !dbg !1133
  %arrayidx = getelementptr inbounds float, ptr %110, i64 0, !dbg !1133
  store float %54, ptr %arrayidx, align 4, !dbg !1134
  %111 = load ptr, ptr %result.addr, align 8, !dbg !1135
  %arrayidx2 = getelementptr inbounds float, ptr %111, i64 0, !dbg !1135
  %112 = load float, ptr %arrayidx2, align 4, !dbg !1135
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %112) #4, !dbg !1136
  %113 = zext i1 %call3 to i64, !dbg !1136
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1136
  %114 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1137
  %arrayidx4 = getelementptr inbounds i32, ptr %114, i64 0, !dbg !1137
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1138
  br label %if.end, !dbg !1139

if.end:                                           ; preds = %109, %entry
  %115 = load i32, ptr %idx, align 4, !dbg !1140
  %cmp5 = icmp eq i32 %115, 1, !dbg !1142
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1142

if.then6:                                         ; preds = %if.end
  %116 = load float, ptr %tiny, align 4, !dbg !1143
  store float %116, ptr %__a.addr.i26, align 4
    #dbg_declare(ptr %__a.addr.i26, !1145, !DIExpression(), !1147)
  store float 5.000000e-01, ptr %__b.addr.i27, align 4
    #dbg_declare(ptr %__b.addr.i27, !1149, !DIExpression(), !1150)
  %117 = load float, ptr %__a.addr.i26, align 4, !dbg !1151
  %118 = load float, ptr %__b.addr.i27, align 4, !dbg !1152
  %119 = bitcast float %117 to i32, !dbg !1153
  %120 = bitcast float %117 to i32, !dbg !1153
  %121 = and i32 %120, 2139095040, !dbg !1153
  %122 = icmp eq i32 %121, 2139095040, !dbg !1153
  %123 = and i32 %120, 8388607, !dbg !1153
  %124 = icmp ne i32 %123, 0, !dbg !1153
  %is_nan16 = and i1 %122, %124, !dbg !1153
  %125 = and i32 %119, 4194304, !dbg !1153
  %126 = icmp eq i32 %125, 0, !dbg !1153
  %is_snan17 = and i1 %is_nan16, %126, !dbg !1153
  %127 = bitcast float %118 to i32, !dbg !1153
  %128 = bitcast float %118 to i32, !dbg !1153
  %129 = and i32 %128, 2139095040, !dbg !1153
  %130 = icmp eq i32 %129, 2139095040, !dbg !1153
  %131 = and i32 %128, 8388607, !dbg !1153
  %132 = icmp ne i32 %131, 0, !dbg !1153
  %is_nan18 = and i1 %130, %132, !dbg !1153
  %133 = and i32 %127, 4194304, !dbg !1153
  %134 = icmp eq i32 %133, 0, !dbg !1153
  %is_snan19 = and i1 %is_nan18, %134, !dbg !1153
  %135 = or i1 %is_snan17, %is_snan19, !dbg !1153
  %136 = bitcast float %117 to i32, !dbg !1153
  %137 = and i32 %136, 2147483647, !dbg !1153
  %is_zero20 = icmp eq i32 %137, 0, !dbg !1153
  %138 = bitcast float %118 to i32, !dbg !1153
  %139 = and i32 %138, 2139095040, !dbg !1153
  %140 = icmp eq i32 %139, 2139095040, !dbg !1153
  %141 = and i32 %138, 8388607, !dbg !1153
  %142 = icmp eq i32 %141, 0, !dbg !1153
  %is_inf21 = and i1 %140, %142, !dbg !1153
  %143 = and i1 %is_zero20, %is_inf21, !dbg !1153
  %144 = bitcast float %117 to i32, !dbg !1153
  %145 = and i32 %144, 2139095040, !dbg !1153
  %146 = icmp eq i32 %145, 2139095040, !dbg !1153
  %147 = and i32 %144, 8388607, !dbg !1153
  %148 = icmp eq i32 %147, 0, !dbg !1153
  %is_inf22 = and i1 %146, %148, !dbg !1153
  %149 = bitcast float %118 to i32, !dbg !1153
  %150 = and i32 %149, 2147483647, !dbg !1153
  %is_zero23 = icmp eq i32 %150, 0, !dbg !1153
  %151 = and i1 %is_inf22, %is_zero23, !dbg !1153
  %152 = or i1 %143, %151, !dbg !1153
  %153 = or i1 %135, %152, !dbg !1153
  br i1 %153, label %154, label %156, !dbg !1153

154:                                              ; preds = %if.then6
  %155 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1153
  br label %156, !dbg !1153

156:                                              ; preds = %if.then6, %154
  %157 = call float @llvm.nvvm.mul.rz.f(float %117, float %118), !dbg !1153
  %158 = bitcast float %117 to i32, !dbg !1154
  %159 = and i32 %158, 2139095040, !dbg !1154
  %is_finite24 = icmp ne i32 %159, 2139095040, !dbg !1154
  %160 = and i1 true, %is_finite24, !dbg !1154
  %161 = bitcast float %118 to i32, !dbg !1154
  %162 = and i32 %161, 2139095040, !dbg !1154
  %is_finite25 = icmp ne i32 %162, 2139095040, !dbg !1154
  %163 = and i1 %160, %is_finite25, !dbg !1154
  %164 = bitcast float %157 to i32, !dbg !1154
  %165 = and i32 %164, 2139095040, !dbg !1154
  %166 = icmp eq i32 %165, 2139095040, !dbg !1154
  %167 = and i32 %164, 8388607, !dbg !1154
  %168 = icmp eq i32 %167, 0, !dbg !1154
  %is_inf26 = and i1 %166, %168, !dbg !1154
  %169 = bitcast float %157 to i32, !dbg !1154
  %170 = and i32 %169, 2147483647, !dbg !1154
  %is_maxfinite27 = icmp eq i32 %170, 2139095039, !dbg !1154
  %171 = bitcast float %157 to i32, !dbg !1154
  %172 = and i32 %171, -2147483648, !dbg !1154
  %173 = icmp eq i32 %172, 0, !dbg !1154
  %174 = icmp ne i32 %172, 0, !dbg !1154
  %is_pos_inf28 = and i1 %is_inf26, %173, !dbg !1154
  %is_neg_inf29 = and i1 %is_inf26, %174, !dbg !1154
  %is_pos_max30 = and i1 %is_maxfinite27, %173, !dbg !1154
  %is_neg_max31 = and i1 %is_maxfinite27, %174, !dbg !1154
  %overflow_cond32 = and i1 %163, %is_maxfinite27, !dbg !1154
  br i1 %overflow_cond32, label %175, label %177, !dbg !1154

175:                                              ; preds = %156
  %176 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1154
  br label %177, !dbg !1154

177:                                              ; preds = %156, %175
  %178 = bitcast float %117 to i32, !dbg !1154
  %179 = and i32 %178, 2139095040, !dbg !1154
  %180 = icmp eq i32 %179, 0, !dbg !1154
  %181 = and i32 %178, 8388607, !dbg !1154
  %182 = icmp ne i32 %181, 0, !dbg !1154
  %is_subnormal33 = and i1 %180, %182, !dbg !1154
  %183 = xor i1 %is_subnormal33, true, !dbg !1154
  %184 = and i1 true, %183, !dbg !1154
  %185 = bitcast float %118 to i32, !dbg !1154
  %186 = and i32 %185, 2139095040, !dbg !1154
  %187 = icmp eq i32 %186, 0, !dbg !1154
  %188 = and i32 %185, 8388607, !dbg !1154
  %189 = icmp ne i32 %188, 0, !dbg !1154
  %is_subnormal34 = and i1 %187, %189, !dbg !1154
  %190 = xor i1 %is_subnormal34, true, !dbg !1154
  %191 = and i1 %184, %190, !dbg !1154
  %192 = bitcast float %157 to i32, !dbg !1154
  %193 = and i32 %192, 2139095040, !dbg !1154
  %194 = icmp eq i32 %193, 0, !dbg !1154
  %195 = and i32 %192, 8388607, !dbg !1154
  %196 = icmp ne i32 %195, 0, !dbg !1154
  %is_subnormal35 = and i1 %194, %196, !dbg !1154
  %197 = bitcast float %157 to i32, !dbg !1154
  %198 = and i32 %197, 2147483647, !dbg !1154
  %is_zero36 = icmp eq i32 %198, 0, !dbg !1154
  %199 = bitcast float %117 to i32, !dbg !1154
  %200 = and i32 %199, 2147483647, !dbg !1154
  %is_zero37 = icmp eq i32 %200, 0, !dbg !1154
  %201 = xor i1 %is_zero37, true, !dbg !1154
  %202 = bitcast float %118 to i32, !dbg !1154
  %203 = and i32 %202, 2147483647, !dbg !1154
  %is_zero38 = icmp eq i32 %203, 0, !dbg !1154
  %204 = xor i1 %is_zero38, true, !dbg !1154
  %205 = and i1 %201, %204, !dbg !1154
  %206 = and i1 %is_zero36, %205, !dbg !1154
  %is_tiny39 = or i1 %is_subnormal35, %206, !dbg !1154
  %underflow_cond40 = and i1 %191, %is_tiny39, !dbg !1154
  br i1 %underflow_cond40, label %207, label %209, !dbg !1154

207:                                              ; preds = %177
  %208 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1154
  br label %209, !dbg !1154

209:                                              ; preds = %177, %207
  %210 = load ptr, ptr %result.addr, align 8, !dbg !1154
  %arrayidx8 = getelementptr inbounds float, ptr %210, i64 1, !dbg !1154
  store float %157, ptr %arrayidx8, align 4, !dbg !1155
  %211 = load ptr, ptr %result.addr, align 8, !dbg !1156
  %arrayidx9 = getelementptr inbounds float, ptr %211, i64 1, !dbg !1156
  %212 = load float, ptr %arrayidx9, align 4, !dbg !1156
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %212) #4, !dbg !1157
  %213 = zext i1 %call10 to i64, !dbg !1157
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1157
  %214 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1158
  %arrayidx12 = getelementptr inbounds i32, ptr %214, i64 1, !dbg !1158
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1159
  br label %if.end13, !dbg !1160

if.end13:                                         ; preds = %209, %if.end
  %215 = load i32, ptr %idx, align 4, !dbg !1161
  %cmp14 = icmp eq i32 %215, 2, !dbg !1163
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1163

if.then15:                                        ; preds = %if.end13
  %216 = load float, ptr %tiny, align 4, !dbg !1164
  store float %216, ptr %__a.addr.i23, align 4
    #dbg_declare(ptr %__a.addr.i23, !1145, !DIExpression(), !1166)
  store float 0x39B4484C00000000, ptr %__b.addr.i24, align 4
    #dbg_declare(ptr %__b.addr.i24, !1149, !DIExpression(), !1168)
  %217 = load float, ptr %__a.addr.i23, align 4, !dbg !1169
  %218 = load float, ptr %__b.addr.i24, align 4, !dbg !1170
  %219 = bitcast float %217 to i32, !dbg !1171
  %220 = bitcast float %217 to i32, !dbg !1171
  %221 = and i32 %220, 2139095040, !dbg !1171
  %222 = icmp eq i32 %221, 2139095040, !dbg !1171
  %223 = and i32 %220, 8388607, !dbg !1171
  %224 = icmp ne i32 %223, 0, !dbg !1171
  %is_nan41 = and i1 %222, %224, !dbg !1171
  %225 = and i32 %219, 4194304, !dbg !1171
  %226 = icmp eq i32 %225, 0, !dbg !1171
  %is_snan42 = and i1 %is_nan41, %226, !dbg !1171
  %227 = bitcast float %218 to i32, !dbg !1171
  %228 = bitcast float %218 to i32, !dbg !1171
  %229 = and i32 %228, 2139095040, !dbg !1171
  %230 = icmp eq i32 %229, 2139095040, !dbg !1171
  %231 = and i32 %228, 8388607, !dbg !1171
  %232 = icmp ne i32 %231, 0, !dbg !1171
  %is_nan43 = and i1 %230, %232, !dbg !1171
  %233 = and i32 %227, 4194304, !dbg !1171
  %234 = icmp eq i32 %233, 0, !dbg !1171
  %is_snan44 = and i1 %is_nan43, %234, !dbg !1171
  %235 = or i1 %is_snan42, %is_snan44, !dbg !1171
  %236 = bitcast float %217 to i32, !dbg !1171
  %237 = and i32 %236, 2147483647, !dbg !1171
  %is_zero45 = icmp eq i32 %237, 0, !dbg !1171
  %238 = bitcast float %218 to i32, !dbg !1171
  %239 = and i32 %238, 2139095040, !dbg !1171
  %240 = icmp eq i32 %239, 2139095040, !dbg !1171
  %241 = and i32 %238, 8388607, !dbg !1171
  %242 = icmp eq i32 %241, 0, !dbg !1171
  %is_inf46 = and i1 %240, %242, !dbg !1171
  %243 = and i1 %is_zero45, %is_inf46, !dbg !1171
  %244 = bitcast float %217 to i32, !dbg !1171
  %245 = and i32 %244, 2139095040, !dbg !1171
  %246 = icmp eq i32 %245, 2139095040, !dbg !1171
  %247 = and i32 %244, 8388607, !dbg !1171
  %248 = icmp eq i32 %247, 0, !dbg !1171
  %is_inf47 = and i1 %246, %248, !dbg !1171
  %249 = bitcast float %218 to i32, !dbg !1171
  %250 = and i32 %249, 2147483647, !dbg !1171
  %is_zero48 = icmp eq i32 %250, 0, !dbg !1171
  %251 = and i1 %is_inf47, %is_zero48, !dbg !1171
  %252 = or i1 %243, %251, !dbg !1171
  %253 = or i1 %235, %252, !dbg !1171
  br i1 %253, label %254, label %256, !dbg !1171

254:                                              ; preds = %if.then15
  %255 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1171
  br label %256, !dbg !1171

256:                                              ; preds = %if.then15, %254
  %257 = call float @llvm.nvvm.mul.rz.f(float %217, float %218), !dbg !1171
  %258 = bitcast float %217 to i32, !dbg !1172
  %259 = and i32 %258, 2139095040, !dbg !1172
  %is_finite49 = icmp ne i32 %259, 2139095040, !dbg !1172
  %260 = and i1 true, %is_finite49, !dbg !1172
  %261 = bitcast float %218 to i32, !dbg !1172
  %262 = and i32 %261, 2139095040, !dbg !1172
  %is_finite50 = icmp ne i32 %262, 2139095040, !dbg !1172
  %263 = and i1 %260, %is_finite50, !dbg !1172
  %264 = bitcast float %257 to i32, !dbg !1172
  %265 = and i32 %264, 2139095040, !dbg !1172
  %266 = icmp eq i32 %265, 2139095040, !dbg !1172
  %267 = and i32 %264, 8388607, !dbg !1172
  %268 = icmp eq i32 %267, 0, !dbg !1172
  %is_inf51 = and i1 %266, %268, !dbg !1172
  %269 = bitcast float %257 to i32, !dbg !1172
  %270 = and i32 %269, 2147483647, !dbg !1172
  %is_maxfinite52 = icmp eq i32 %270, 2139095039, !dbg !1172
  %271 = bitcast float %257 to i32, !dbg !1172
  %272 = and i32 %271, -2147483648, !dbg !1172
  %273 = icmp eq i32 %272, 0, !dbg !1172
  %274 = icmp ne i32 %272, 0, !dbg !1172
  %is_pos_inf53 = and i1 %is_inf51, %273, !dbg !1172
  %is_neg_inf54 = and i1 %is_inf51, %274, !dbg !1172
  %is_pos_max55 = and i1 %is_maxfinite52, %273, !dbg !1172
  %is_neg_max56 = and i1 %is_maxfinite52, %274, !dbg !1172
  %overflow_cond57 = and i1 %263, %is_maxfinite52, !dbg !1172
  br i1 %overflow_cond57, label %275, label %277, !dbg !1172

275:                                              ; preds = %256
  %276 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1172
  br label %277, !dbg !1172

277:                                              ; preds = %256, %275
  %278 = bitcast float %217 to i32, !dbg !1172
  %279 = and i32 %278, 2139095040, !dbg !1172
  %280 = icmp eq i32 %279, 0, !dbg !1172
  %281 = and i32 %278, 8388607, !dbg !1172
  %282 = icmp ne i32 %281, 0, !dbg !1172
  %is_subnormal58 = and i1 %280, %282, !dbg !1172
  %283 = xor i1 %is_subnormal58, true, !dbg !1172
  %284 = and i1 true, %283, !dbg !1172
  %285 = bitcast float %218 to i32, !dbg !1172
  %286 = and i32 %285, 2139095040, !dbg !1172
  %287 = icmp eq i32 %286, 0, !dbg !1172
  %288 = and i32 %285, 8388607, !dbg !1172
  %289 = icmp ne i32 %288, 0, !dbg !1172
  %is_subnormal59 = and i1 %287, %289, !dbg !1172
  %290 = xor i1 %is_subnormal59, true, !dbg !1172
  %291 = and i1 %284, %290, !dbg !1172
  %292 = bitcast float %257 to i32, !dbg !1172
  %293 = and i32 %292, 2139095040, !dbg !1172
  %294 = icmp eq i32 %293, 0, !dbg !1172
  %295 = and i32 %292, 8388607, !dbg !1172
  %296 = icmp ne i32 %295, 0, !dbg !1172
  %is_subnormal60 = and i1 %294, %296, !dbg !1172
  %297 = bitcast float %257 to i32, !dbg !1172
  %298 = and i32 %297, 2147483647, !dbg !1172
  %is_zero61 = icmp eq i32 %298, 0, !dbg !1172
  %299 = bitcast float %217 to i32, !dbg !1172
  %300 = and i32 %299, 2147483647, !dbg !1172
  %is_zero62 = icmp eq i32 %300, 0, !dbg !1172
  %301 = xor i1 %is_zero62, true, !dbg !1172
  %302 = bitcast float %218 to i32, !dbg !1172
  %303 = and i32 %302, 2147483647, !dbg !1172
  %is_zero63 = icmp eq i32 %303, 0, !dbg !1172
  %304 = xor i1 %is_zero63, true, !dbg !1172
  %305 = and i1 %301, %304, !dbg !1172
  %306 = and i1 %is_zero61, %305, !dbg !1172
  %is_tiny64 = or i1 %is_subnormal60, %306, !dbg !1172
  %underflow_cond65 = and i1 %291, %is_tiny64, !dbg !1172
  br i1 %underflow_cond65, label %307, label %309, !dbg !1172

307:                                              ; preds = %277
  %308 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1172
  br label %309, !dbg !1172

309:                                              ; preds = %277, %307
  %310 = load ptr, ptr %result.addr, align 8, !dbg !1172
  %arrayidx17 = getelementptr inbounds float, ptr %310, i64 2, !dbg !1172
  store float %257, ptr %arrayidx17, align 4, !dbg !1173
  %311 = load ptr, ptr %result.addr, align 8, !dbg !1174
  %arrayidx18 = getelementptr inbounds float, ptr %311, i64 2, !dbg !1174
  %312 = load float, ptr %arrayidx18, align 4, !dbg !1174
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %312) #4, !dbg !1175
  %313 = zext i1 %call19 to i64, !dbg !1175
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1175
  %314 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1176
  %arrayidx21 = getelementptr inbounds i32, ptr %314, i64 2, !dbg !1176
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1177
  br label %if.end22, !dbg !1178

if.end22:                                         ; preds = %309, %if.end13
  ret void, !dbg !1179
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rz.f(float, float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z21testUnderflow_RoundUpPfPi(ptr noundef %result, ptr noundef %is_denormal) #2 !dbg !1180 {
entry:
  %__a.addr.i26 = alloca float, align 4
  %__b.addr.i27 = alloca float, align 4
  %__a.addr.i23 = alloca float, align 4
  %__b.addr.i24 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1181, !DIExpression(), !1182)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1183, !DIExpression(), !1184)
    #dbg_declare(ptr %idx, !1185, !DIExpression(), !1186)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1187
  store i32 %0, ptr %idx, align 4, !dbg !1186
    #dbg_declare(ptr %tiny, !1189, !DIExpression(), !1190)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1190
  %1 = load i32, ptr %idx, align 4, !dbg !1191
  %cmp = icmp eq i32 %1, 0, !dbg !1193
  br i1 %cmp, label %if.then, label %if.end, !dbg !1193

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1194
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1196, !DIExpression(), !1198)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1200, !DIExpression(), !1201)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1202
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1203
  %5 = bitcast float %3 to i32, !dbg !1204
  %6 = bitcast float %3 to i32, !dbg !1204
  %7 = and i32 %6, 2139095040, !dbg !1204
  %8 = icmp eq i32 %7, 2139095040, !dbg !1204
  %9 = and i32 %6, 8388607, !dbg !1204
  %10 = icmp ne i32 %9, 0, !dbg !1204
  %is_nan = and i1 %8, %10, !dbg !1204
  %11 = and i32 %5, 4194304, !dbg !1204
  %12 = icmp eq i32 %11, 0, !dbg !1204
  %is_snan = and i1 %is_nan, %12, !dbg !1204
  %13 = bitcast float %4 to i32, !dbg !1204
  %14 = bitcast float %4 to i32, !dbg !1204
  %15 = and i32 %14, 2139095040, !dbg !1204
  %16 = icmp eq i32 %15, 2139095040, !dbg !1204
  %17 = and i32 %14, 8388607, !dbg !1204
  %18 = icmp ne i32 %17, 0, !dbg !1204
  %is_nan1 = and i1 %16, %18, !dbg !1204
  %19 = and i32 %13, 4194304, !dbg !1204
  %20 = icmp eq i32 %19, 0, !dbg !1204
  %is_snan2 = and i1 %is_nan1, %20, !dbg !1204
  %21 = or i1 %is_snan, %is_snan2, !dbg !1204
  %22 = bitcast float %3 to i32, !dbg !1204
  %23 = and i32 %22, 2147483647, !dbg !1204
  %is_zero = icmp eq i32 %23, 0, !dbg !1204
  %24 = bitcast float %4 to i32, !dbg !1204
  %25 = and i32 %24, 2147483647, !dbg !1204
  %is_zero3 = icmp eq i32 %25, 0, !dbg !1204
  %26 = and i1 %is_zero, %is_zero3, !dbg !1204
  %27 = bitcast float %3 to i32, !dbg !1204
  %28 = and i32 %27, 2139095040, !dbg !1204
  %29 = icmp eq i32 %28, 2139095040, !dbg !1204
  %30 = and i32 %27, 8388607, !dbg !1204
  %31 = icmp eq i32 %30, 0, !dbg !1204
  %is_inf = and i1 %29, %31, !dbg !1204
  %32 = bitcast float %4 to i32, !dbg !1204
  %33 = and i32 %32, 2139095040, !dbg !1204
  %34 = icmp eq i32 %33, 2139095040, !dbg !1204
  %35 = and i32 %32, 8388607, !dbg !1204
  %36 = icmp eq i32 %35, 0, !dbg !1204
  %is_inf4 = and i1 %34, %36, !dbg !1204
  %37 = and i1 %is_inf, %is_inf4, !dbg !1204
  %38 = or i1 %26, %37, !dbg !1204
  %39 = or i1 %21, %38, !dbg !1204
  br i1 %39, label %40, label %42, !dbg !1204

40:                                               ; preds = %if.then
  %41 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1204
  br label %42, !dbg !1204

42:                                               ; preds = %if.then, %40
  %43 = bitcast float %4 to i32, !dbg !1204
  %44 = and i32 %43, 2147483647, !dbg !1204
  %is_zero5 = icmp eq i32 %44, 0, !dbg !1204
  %45 = bitcast float %3 to i32, !dbg !1204
  %46 = and i32 %45, 2139095040, !dbg !1204
  %is_finite = icmp ne i32 %46, 2139095040, !dbg !1204
  %47 = bitcast float %3 to i32, !dbg !1204
  %48 = and i32 %47, 2147483647, !dbg !1204
  %is_zero6 = icmp eq i32 %48, 0, !dbg !1204
  %49 = xor i1 %is_zero6, true, !dbg !1204
  %50 = and i1 %is_finite, %49, !dbg !1204
  %divzero_cond = and i1 %is_zero5, %50, !dbg !1204
  br i1 %divzero_cond, label %51, label %53, !dbg !1204

51:                                               ; preds = %42
  %52 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !1204
  br label %53, !dbg !1204

53:                                               ; preds = %42, %51
  %54 = call float @llvm.nvvm.div.rp.f(float %3, float %4), !dbg !1204
  %55 = bitcast float %3 to i32, !dbg !1205
  %56 = and i32 %55, 2139095040, !dbg !1205
  %is_finite7 = icmp ne i32 %56, 2139095040, !dbg !1205
  %57 = and i1 true, %is_finite7, !dbg !1205
  %58 = bitcast float %4 to i32, !dbg !1205
  %59 = and i32 %58, 2139095040, !dbg !1205
  %is_finite8 = icmp ne i32 %59, 2139095040, !dbg !1205
  %60 = and i1 %57, %is_finite8, !dbg !1205
  %61 = bitcast float %4 to i32, !dbg !1205
  %62 = and i32 %61, 2147483647, !dbg !1205
  %is_zero9 = icmp eq i32 %62, 0, !dbg !1205
  %63 = xor i1 %is_zero9, true, !dbg !1205
  %overflow_denom_nonzero = and i1 %60, %63, !dbg !1205
  %64 = bitcast float %54 to i32, !dbg !1205
  %65 = and i32 %64, 2139095040, !dbg !1205
  %66 = icmp eq i32 %65, 2139095040, !dbg !1205
  %67 = and i32 %64, 8388607, !dbg !1205
  %68 = icmp eq i32 %67, 0, !dbg !1205
  %is_inf10 = and i1 %66, %68, !dbg !1205
  %69 = bitcast float %54 to i32, !dbg !1205
  %70 = and i32 %69, 2147483647, !dbg !1205
  %is_maxfinite = icmp eq i32 %70, 2139095039, !dbg !1205
  %71 = bitcast float %54 to i32, !dbg !1205
  %72 = and i32 %71, -2147483648, !dbg !1205
  %73 = icmp eq i32 %72, 0, !dbg !1205
  %74 = icmp ne i32 %72, 0, !dbg !1205
  %is_pos_inf = and i1 %is_inf10, %73, !dbg !1205
  %is_neg_inf = and i1 %is_inf10, %74, !dbg !1205
  %is_pos_max = and i1 %is_maxfinite, %73, !dbg !1205
  %is_neg_max = and i1 %is_maxfinite, %74, !dbg !1205
  %overflow_rp = or i1 %is_pos_inf, %is_neg_max, !dbg !1205
  %overflow_cond = and i1 %overflow_denom_nonzero, %overflow_rp, !dbg !1205
  br i1 %overflow_cond, label %75, label %77, !dbg !1205

75:                                               ; preds = %53
  %76 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1205
  br label %77, !dbg !1205

77:                                               ; preds = %53, %75
  %78 = bitcast float %3 to i32, !dbg !1205
  %79 = and i32 %78, 2139095040, !dbg !1205
  %80 = icmp eq i32 %79, 0, !dbg !1205
  %81 = and i32 %78, 8388607, !dbg !1205
  %82 = icmp ne i32 %81, 0, !dbg !1205
  %is_subnormal = and i1 %80, %82, !dbg !1205
  %83 = xor i1 %is_subnormal, true, !dbg !1205
  %84 = and i1 true, %83, !dbg !1205
  %85 = bitcast float %4 to i32, !dbg !1205
  %86 = and i32 %85, 2139095040, !dbg !1205
  %87 = icmp eq i32 %86, 0, !dbg !1205
  %88 = and i32 %85, 8388607, !dbg !1205
  %89 = icmp ne i32 %88, 0, !dbg !1205
  %is_subnormal11 = and i1 %87, %89, !dbg !1205
  %90 = xor i1 %is_subnormal11, true, !dbg !1205
  %91 = and i1 %84, %90, !dbg !1205
  %92 = bitcast float %54 to i32, !dbg !1205
  %93 = and i32 %92, 2139095040, !dbg !1205
  %94 = icmp eq i32 %93, 0, !dbg !1205
  %95 = and i32 %92, 8388607, !dbg !1205
  %96 = icmp ne i32 %95, 0, !dbg !1205
  %is_subnormal12 = and i1 %94, %96, !dbg !1205
  %97 = bitcast float %54 to i32, !dbg !1205
  %98 = and i32 %97, 2147483647, !dbg !1205
  %is_zero13 = icmp eq i32 %98, 0, !dbg !1205
  %99 = bitcast float %3 to i32, !dbg !1205
  %100 = and i32 %99, 2147483647, !dbg !1205
  %is_zero14 = icmp eq i32 %100, 0, !dbg !1205
  %101 = xor i1 %is_zero14, true, !dbg !1205
  %102 = bitcast float %4 to i32, !dbg !1205
  %103 = and i32 %102, 2147483647, !dbg !1205
  %is_zero15 = icmp eq i32 %103, 0, !dbg !1205
  %104 = xor i1 %is_zero15, true, !dbg !1205
  %105 = and i1 %101, %104, !dbg !1205
  %106 = and i1 %is_zero13, %105, !dbg !1205
  %is_tiny = or i1 %is_subnormal12, %106, !dbg !1205
  %underflow_cond = and i1 %91, %is_tiny, !dbg !1205
  br i1 %underflow_cond, label %107, label %109, !dbg !1205

107:                                              ; preds = %77
  %108 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1205
  br label %109, !dbg !1205

109:                                              ; preds = %77, %107
  %110 = load ptr, ptr %result.addr, align 8, !dbg !1205
  %arrayidx = getelementptr inbounds float, ptr %110, i64 0, !dbg !1205
  store float %54, ptr %arrayidx, align 4, !dbg !1206
  %111 = load ptr, ptr %result.addr, align 8, !dbg !1207
  %arrayidx2 = getelementptr inbounds float, ptr %111, i64 0, !dbg !1207
  %112 = load float, ptr %arrayidx2, align 4, !dbg !1207
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %112) #4, !dbg !1208
  %113 = zext i1 %call3 to i64, !dbg !1208
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1208
  %114 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1209
  %arrayidx4 = getelementptr inbounds i32, ptr %114, i64 0, !dbg !1209
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1210
  br label %if.end, !dbg !1211

if.end:                                           ; preds = %109, %entry
  %115 = load i32, ptr %idx, align 4, !dbg !1212
  %cmp5 = icmp eq i32 %115, 1, !dbg !1214
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1214

if.then6:                                         ; preds = %if.end
  %116 = load float, ptr %tiny, align 4, !dbg !1215
  store float %116, ptr %__a.addr.i26, align 4
    #dbg_declare(ptr %__a.addr.i26, !1217, !DIExpression(), !1219)
  store float 5.000000e-01, ptr %__b.addr.i27, align 4
    #dbg_declare(ptr %__b.addr.i27, !1221, !DIExpression(), !1222)
  %117 = load float, ptr %__a.addr.i26, align 4, !dbg !1223
  %118 = load float, ptr %__b.addr.i27, align 4, !dbg !1224
  %119 = bitcast float %117 to i32, !dbg !1225
  %120 = bitcast float %117 to i32, !dbg !1225
  %121 = and i32 %120, 2139095040, !dbg !1225
  %122 = icmp eq i32 %121, 2139095040, !dbg !1225
  %123 = and i32 %120, 8388607, !dbg !1225
  %124 = icmp ne i32 %123, 0, !dbg !1225
  %is_nan16 = and i1 %122, %124, !dbg !1225
  %125 = and i32 %119, 4194304, !dbg !1225
  %126 = icmp eq i32 %125, 0, !dbg !1225
  %is_snan17 = and i1 %is_nan16, %126, !dbg !1225
  %127 = bitcast float %118 to i32, !dbg !1225
  %128 = bitcast float %118 to i32, !dbg !1225
  %129 = and i32 %128, 2139095040, !dbg !1225
  %130 = icmp eq i32 %129, 2139095040, !dbg !1225
  %131 = and i32 %128, 8388607, !dbg !1225
  %132 = icmp ne i32 %131, 0, !dbg !1225
  %is_nan18 = and i1 %130, %132, !dbg !1225
  %133 = and i32 %127, 4194304, !dbg !1225
  %134 = icmp eq i32 %133, 0, !dbg !1225
  %is_snan19 = and i1 %is_nan18, %134, !dbg !1225
  %135 = or i1 %is_snan17, %is_snan19, !dbg !1225
  %136 = bitcast float %117 to i32, !dbg !1225
  %137 = and i32 %136, 2147483647, !dbg !1225
  %is_zero20 = icmp eq i32 %137, 0, !dbg !1225
  %138 = bitcast float %118 to i32, !dbg !1225
  %139 = and i32 %138, 2139095040, !dbg !1225
  %140 = icmp eq i32 %139, 2139095040, !dbg !1225
  %141 = and i32 %138, 8388607, !dbg !1225
  %142 = icmp eq i32 %141, 0, !dbg !1225
  %is_inf21 = and i1 %140, %142, !dbg !1225
  %143 = and i1 %is_zero20, %is_inf21, !dbg !1225
  %144 = bitcast float %117 to i32, !dbg !1225
  %145 = and i32 %144, 2139095040, !dbg !1225
  %146 = icmp eq i32 %145, 2139095040, !dbg !1225
  %147 = and i32 %144, 8388607, !dbg !1225
  %148 = icmp eq i32 %147, 0, !dbg !1225
  %is_inf22 = and i1 %146, %148, !dbg !1225
  %149 = bitcast float %118 to i32, !dbg !1225
  %150 = and i32 %149, 2147483647, !dbg !1225
  %is_zero23 = icmp eq i32 %150, 0, !dbg !1225
  %151 = and i1 %is_inf22, %is_zero23, !dbg !1225
  %152 = or i1 %143, %151, !dbg !1225
  %153 = or i1 %135, %152, !dbg !1225
  br i1 %153, label %154, label %156, !dbg !1225

154:                                              ; preds = %if.then6
  %155 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1225
  br label %156, !dbg !1225

156:                                              ; preds = %if.then6, %154
  %157 = call float @llvm.nvvm.mul.rp.f(float %117, float %118), !dbg !1225
  %158 = bitcast float %117 to i32, !dbg !1226
  %159 = and i32 %158, 2139095040, !dbg !1226
  %is_finite24 = icmp ne i32 %159, 2139095040, !dbg !1226
  %160 = and i1 true, %is_finite24, !dbg !1226
  %161 = bitcast float %118 to i32, !dbg !1226
  %162 = and i32 %161, 2139095040, !dbg !1226
  %is_finite25 = icmp ne i32 %162, 2139095040, !dbg !1226
  %163 = and i1 %160, %is_finite25, !dbg !1226
  %164 = bitcast float %157 to i32, !dbg !1226
  %165 = and i32 %164, 2139095040, !dbg !1226
  %166 = icmp eq i32 %165, 2139095040, !dbg !1226
  %167 = and i32 %164, 8388607, !dbg !1226
  %168 = icmp eq i32 %167, 0, !dbg !1226
  %is_inf26 = and i1 %166, %168, !dbg !1226
  %169 = bitcast float %157 to i32, !dbg !1226
  %170 = and i32 %169, 2147483647, !dbg !1226
  %is_maxfinite27 = icmp eq i32 %170, 2139095039, !dbg !1226
  %171 = bitcast float %157 to i32, !dbg !1226
  %172 = and i32 %171, -2147483648, !dbg !1226
  %173 = icmp eq i32 %172, 0, !dbg !1226
  %174 = icmp ne i32 %172, 0, !dbg !1226
  %is_pos_inf28 = and i1 %is_inf26, %173, !dbg !1226
  %is_neg_inf29 = and i1 %is_inf26, %174, !dbg !1226
  %is_pos_max30 = and i1 %is_maxfinite27, %173, !dbg !1226
  %is_neg_max31 = and i1 %is_maxfinite27, %174, !dbg !1226
  %overflow_rp32 = or i1 %is_pos_inf28, %is_neg_max31, !dbg !1226
  %overflow_cond33 = and i1 %163, %overflow_rp32, !dbg !1226
  br i1 %overflow_cond33, label %175, label %177, !dbg !1226

175:                                              ; preds = %156
  %176 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1226
  br label %177, !dbg !1226

177:                                              ; preds = %156, %175
  %178 = bitcast float %117 to i32, !dbg !1226
  %179 = and i32 %178, 2139095040, !dbg !1226
  %180 = icmp eq i32 %179, 0, !dbg !1226
  %181 = and i32 %178, 8388607, !dbg !1226
  %182 = icmp ne i32 %181, 0, !dbg !1226
  %is_subnormal34 = and i1 %180, %182, !dbg !1226
  %183 = xor i1 %is_subnormal34, true, !dbg !1226
  %184 = and i1 true, %183, !dbg !1226
  %185 = bitcast float %118 to i32, !dbg !1226
  %186 = and i32 %185, 2139095040, !dbg !1226
  %187 = icmp eq i32 %186, 0, !dbg !1226
  %188 = and i32 %185, 8388607, !dbg !1226
  %189 = icmp ne i32 %188, 0, !dbg !1226
  %is_subnormal35 = and i1 %187, %189, !dbg !1226
  %190 = xor i1 %is_subnormal35, true, !dbg !1226
  %191 = and i1 %184, %190, !dbg !1226
  %192 = bitcast float %157 to i32, !dbg !1226
  %193 = and i32 %192, 2139095040, !dbg !1226
  %194 = icmp eq i32 %193, 0, !dbg !1226
  %195 = and i32 %192, 8388607, !dbg !1226
  %196 = icmp ne i32 %195, 0, !dbg !1226
  %is_subnormal36 = and i1 %194, %196, !dbg !1226
  %197 = bitcast float %157 to i32, !dbg !1226
  %198 = and i32 %197, 2147483647, !dbg !1226
  %is_zero37 = icmp eq i32 %198, 0, !dbg !1226
  %199 = bitcast float %117 to i32, !dbg !1226
  %200 = and i32 %199, 2147483647, !dbg !1226
  %is_zero38 = icmp eq i32 %200, 0, !dbg !1226
  %201 = xor i1 %is_zero38, true, !dbg !1226
  %202 = bitcast float %118 to i32, !dbg !1226
  %203 = and i32 %202, 2147483647, !dbg !1226
  %is_zero39 = icmp eq i32 %203, 0, !dbg !1226
  %204 = xor i1 %is_zero39, true, !dbg !1226
  %205 = and i1 %201, %204, !dbg !1226
  %206 = and i1 %is_zero37, %205, !dbg !1226
  %is_tiny40 = or i1 %is_subnormal36, %206, !dbg !1226
  %underflow_cond41 = and i1 %191, %is_tiny40, !dbg !1226
  br i1 %underflow_cond41, label %207, label %209, !dbg !1226

207:                                              ; preds = %177
  %208 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1226
  br label %209, !dbg !1226

209:                                              ; preds = %177, %207
  %210 = load ptr, ptr %result.addr, align 8, !dbg !1226
  %arrayidx8 = getelementptr inbounds float, ptr %210, i64 1, !dbg !1226
  store float %157, ptr %arrayidx8, align 4, !dbg !1227
  %211 = load ptr, ptr %result.addr, align 8, !dbg !1228
  %arrayidx9 = getelementptr inbounds float, ptr %211, i64 1, !dbg !1228
  %212 = load float, ptr %arrayidx9, align 4, !dbg !1228
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %212) #4, !dbg !1229
  %213 = zext i1 %call10 to i64, !dbg !1229
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1229
  %214 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1230
  %arrayidx12 = getelementptr inbounds i32, ptr %214, i64 1, !dbg !1230
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1231
  br label %if.end13, !dbg !1232

if.end13:                                         ; preds = %209, %if.end
  %215 = load i32, ptr %idx, align 4, !dbg !1233
  %cmp14 = icmp eq i32 %215, 2, !dbg !1235
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1235

if.then15:                                        ; preds = %if.end13
  %216 = load float, ptr %tiny, align 4, !dbg !1236
  %fneg = fneg contract float %216, !dbg !1238
  store float %fneg, ptr %__a.addr.i23, align 4
    #dbg_declare(ptr %__a.addr.i23, !1217, !DIExpression(), !1239)
  store float 5.000000e-01, ptr %__b.addr.i24, align 4
    #dbg_declare(ptr %__b.addr.i24, !1221, !DIExpression(), !1241)
  %217 = load float, ptr %__a.addr.i23, align 4, !dbg !1242
  %218 = load float, ptr %__b.addr.i24, align 4, !dbg !1243
  %219 = bitcast float %217 to i32, !dbg !1244
  %220 = bitcast float %217 to i32, !dbg !1244
  %221 = and i32 %220, 2139095040, !dbg !1244
  %222 = icmp eq i32 %221, 2139095040, !dbg !1244
  %223 = and i32 %220, 8388607, !dbg !1244
  %224 = icmp ne i32 %223, 0, !dbg !1244
  %is_nan42 = and i1 %222, %224, !dbg !1244
  %225 = and i32 %219, 4194304, !dbg !1244
  %226 = icmp eq i32 %225, 0, !dbg !1244
  %is_snan43 = and i1 %is_nan42, %226, !dbg !1244
  %227 = bitcast float %218 to i32, !dbg !1244
  %228 = bitcast float %218 to i32, !dbg !1244
  %229 = and i32 %228, 2139095040, !dbg !1244
  %230 = icmp eq i32 %229, 2139095040, !dbg !1244
  %231 = and i32 %228, 8388607, !dbg !1244
  %232 = icmp ne i32 %231, 0, !dbg !1244
  %is_nan44 = and i1 %230, %232, !dbg !1244
  %233 = and i32 %227, 4194304, !dbg !1244
  %234 = icmp eq i32 %233, 0, !dbg !1244
  %is_snan45 = and i1 %is_nan44, %234, !dbg !1244
  %235 = or i1 %is_snan43, %is_snan45, !dbg !1244
  %236 = bitcast float %217 to i32, !dbg !1244
  %237 = and i32 %236, 2147483647, !dbg !1244
  %is_zero46 = icmp eq i32 %237, 0, !dbg !1244
  %238 = bitcast float %218 to i32, !dbg !1244
  %239 = and i32 %238, 2139095040, !dbg !1244
  %240 = icmp eq i32 %239, 2139095040, !dbg !1244
  %241 = and i32 %238, 8388607, !dbg !1244
  %242 = icmp eq i32 %241, 0, !dbg !1244
  %is_inf47 = and i1 %240, %242, !dbg !1244
  %243 = and i1 %is_zero46, %is_inf47, !dbg !1244
  %244 = bitcast float %217 to i32, !dbg !1244
  %245 = and i32 %244, 2139095040, !dbg !1244
  %246 = icmp eq i32 %245, 2139095040, !dbg !1244
  %247 = and i32 %244, 8388607, !dbg !1244
  %248 = icmp eq i32 %247, 0, !dbg !1244
  %is_inf48 = and i1 %246, %248, !dbg !1244
  %249 = bitcast float %218 to i32, !dbg !1244
  %250 = and i32 %249, 2147483647, !dbg !1244
  %is_zero49 = icmp eq i32 %250, 0, !dbg !1244
  %251 = and i1 %is_inf48, %is_zero49, !dbg !1244
  %252 = or i1 %243, %251, !dbg !1244
  %253 = or i1 %235, %252, !dbg !1244
  br i1 %253, label %254, label %256, !dbg !1244

254:                                              ; preds = %if.then15
  %255 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1244
  br label %256, !dbg !1244

256:                                              ; preds = %if.then15, %254
  %257 = call float @llvm.nvvm.mul.rp.f(float %217, float %218), !dbg !1244
  %258 = bitcast float %217 to i32, !dbg !1245
  %259 = and i32 %258, 2139095040, !dbg !1245
  %is_finite50 = icmp ne i32 %259, 2139095040, !dbg !1245
  %260 = and i1 true, %is_finite50, !dbg !1245
  %261 = bitcast float %218 to i32, !dbg !1245
  %262 = and i32 %261, 2139095040, !dbg !1245
  %is_finite51 = icmp ne i32 %262, 2139095040, !dbg !1245
  %263 = and i1 %260, %is_finite51, !dbg !1245
  %264 = bitcast float %257 to i32, !dbg !1245
  %265 = and i32 %264, 2139095040, !dbg !1245
  %266 = icmp eq i32 %265, 2139095040, !dbg !1245
  %267 = and i32 %264, 8388607, !dbg !1245
  %268 = icmp eq i32 %267, 0, !dbg !1245
  %is_inf52 = and i1 %266, %268, !dbg !1245
  %269 = bitcast float %257 to i32, !dbg !1245
  %270 = and i32 %269, 2147483647, !dbg !1245
  %is_maxfinite53 = icmp eq i32 %270, 2139095039, !dbg !1245
  %271 = bitcast float %257 to i32, !dbg !1245
  %272 = and i32 %271, -2147483648, !dbg !1245
  %273 = icmp eq i32 %272, 0, !dbg !1245
  %274 = icmp ne i32 %272, 0, !dbg !1245
  %is_pos_inf54 = and i1 %is_inf52, %273, !dbg !1245
  %is_neg_inf55 = and i1 %is_inf52, %274, !dbg !1245
  %is_pos_max56 = and i1 %is_maxfinite53, %273, !dbg !1245
  %is_neg_max57 = and i1 %is_maxfinite53, %274, !dbg !1245
  %overflow_rp58 = or i1 %is_pos_inf54, %is_neg_max57, !dbg !1245
  %overflow_cond59 = and i1 %263, %overflow_rp58, !dbg !1245
  br i1 %overflow_cond59, label %275, label %277, !dbg !1245

275:                                              ; preds = %256
  %276 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1245
  br label %277, !dbg !1245

277:                                              ; preds = %256, %275
  %278 = bitcast float %217 to i32, !dbg !1245
  %279 = and i32 %278, 2139095040, !dbg !1245
  %280 = icmp eq i32 %279, 0, !dbg !1245
  %281 = and i32 %278, 8388607, !dbg !1245
  %282 = icmp ne i32 %281, 0, !dbg !1245
  %is_subnormal60 = and i1 %280, %282, !dbg !1245
  %283 = xor i1 %is_subnormal60, true, !dbg !1245
  %284 = and i1 true, %283, !dbg !1245
  %285 = bitcast float %218 to i32, !dbg !1245
  %286 = and i32 %285, 2139095040, !dbg !1245
  %287 = icmp eq i32 %286, 0, !dbg !1245
  %288 = and i32 %285, 8388607, !dbg !1245
  %289 = icmp ne i32 %288, 0, !dbg !1245
  %is_subnormal61 = and i1 %287, %289, !dbg !1245
  %290 = xor i1 %is_subnormal61, true, !dbg !1245
  %291 = and i1 %284, %290, !dbg !1245
  %292 = bitcast float %257 to i32, !dbg !1245
  %293 = and i32 %292, 2139095040, !dbg !1245
  %294 = icmp eq i32 %293, 0, !dbg !1245
  %295 = and i32 %292, 8388607, !dbg !1245
  %296 = icmp ne i32 %295, 0, !dbg !1245
  %is_subnormal62 = and i1 %294, %296, !dbg !1245
  %297 = bitcast float %257 to i32, !dbg !1245
  %298 = and i32 %297, 2147483647, !dbg !1245
  %is_zero63 = icmp eq i32 %298, 0, !dbg !1245
  %299 = bitcast float %217 to i32, !dbg !1245
  %300 = and i32 %299, 2147483647, !dbg !1245
  %is_zero64 = icmp eq i32 %300, 0, !dbg !1245
  %301 = xor i1 %is_zero64, true, !dbg !1245
  %302 = bitcast float %218 to i32, !dbg !1245
  %303 = and i32 %302, 2147483647, !dbg !1245
  %is_zero65 = icmp eq i32 %303, 0, !dbg !1245
  %304 = xor i1 %is_zero65, true, !dbg !1245
  %305 = and i1 %301, %304, !dbg !1245
  %306 = and i1 %is_zero63, %305, !dbg !1245
  %is_tiny66 = or i1 %is_subnormal62, %306, !dbg !1245
  %underflow_cond67 = and i1 %291, %is_tiny66, !dbg !1245
  br i1 %underflow_cond67, label %307, label %309, !dbg !1245

307:                                              ; preds = %277
  %308 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1245
  br label %309, !dbg !1245

309:                                              ; preds = %277, %307
  %310 = load ptr, ptr %result.addr, align 8, !dbg !1245
  %arrayidx17 = getelementptr inbounds float, ptr %310, i64 2, !dbg !1245
  store float %257, ptr %arrayidx17, align 4, !dbg !1246
  %311 = load ptr, ptr %result.addr, align 8, !dbg !1247
  %arrayidx18 = getelementptr inbounds float, ptr %311, i64 2, !dbg !1247
  %312 = load float, ptr %arrayidx18, align 4, !dbg !1247
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %312) #4, !dbg !1248
  %313 = zext i1 %call19 to i64, !dbg !1248
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1248
  %314 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1249
  %arrayidx21 = getelementptr inbounds i32, ptr %314, i64 2, !dbg !1249
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1250
  br label %if.end22, !dbg !1251

if.end22:                                         ; preds = %309, %if.end13
  ret void, !dbg !1252
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rp.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rp.f(float, float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z23testUnderflow_RoundDownPfPi(ptr noundef %result, ptr noundef %is_denormal) #2 !dbg !1253 {
entry:
  %__a.addr.i27 = alloca float, align 4
  %__b.addr.i28 = alloca float, align 4
  %__a.addr.i24 = alloca float, align 4
  %__b.addr.i25 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1254, !DIExpression(), !1255)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1256, !DIExpression(), !1257)
    #dbg_declare(ptr %idx, !1258, !DIExpression(), !1259)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1260
  store i32 %0, ptr %idx, align 4, !dbg !1259
    #dbg_declare(ptr %tiny, !1262, !DIExpression(), !1263)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1263
  %1 = load i32, ptr %idx, align 4, !dbg !1264
  %cmp = icmp eq i32 %1, 0, !dbg !1266
  br i1 %cmp, label %if.then, label %if.end, !dbg !1266

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1267
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1269, !DIExpression(), !1271)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1273, !DIExpression(), !1274)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1275
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1276
  %5 = bitcast float %3 to i32, !dbg !1277
  %6 = bitcast float %3 to i32, !dbg !1277
  %7 = and i32 %6, 2139095040, !dbg !1277
  %8 = icmp eq i32 %7, 2139095040, !dbg !1277
  %9 = and i32 %6, 8388607, !dbg !1277
  %10 = icmp ne i32 %9, 0, !dbg !1277
  %is_nan = and i1 %8, %10, !dbg !1277
  %11 = and i32 %5, 4194304, !dbg !1277
  %12 = icmp eq i32 %11, 0, !dbg !1277
  %is_snan = and i1 %is_nan, %12, !dbg !1277
  %13 = bitcast float %4 to i32, !dbg !1277
  %14 = bitcast float %4 to i32, !dbg !1277
  %15 = and i32 %14, 2139095040, !dbg !1277
  %16 = icmp eq i32 %15, 2139095040, !dbg !1277
  %17 = and i32 %14, 8388607, !dbg !1277
  %18 = icmp ne i32 %17, 0, !dbg !1277
  %is_nan1 = and i1 %16, %18, !dbg !1277
  %19 = and i32 %13, 4194304, !dbg !1277
  %20 = icmp eq i32 %19, 0, !dbg !1277
  %is_snan2 = and i1 %is_nan1, %20, !dbg !1277
  %21 = or i1 %is_snan, %is_snan2, !dbg !1277
  %22 = bitcast float %3 to i32, !dbg !1277
  %23 = and i32 %22, 2147483647, !dbg !1277
  %is_zero = icmp eq i32 %23, 0, !dbg !1277
  %24 = bitcast float %4 to i32, !dbg !1277
  %25 = and i32 %24, 2147483647, !dbg !1277
  %is_zero3 = icmp eq i32 %25, 0, !dbg !1277
  %26 = and i1 %is_zero, %is_zero3, !dbg !1277
  %27 = bitcast float %3 to i32, !dbg !1277
  %28 = and i32 %27, 2139095040, !dbg !1277
  %29 = icmp eq i32 %28, 2139095040, !dbg !1277
  %30 = and i32 %27, 8388607, !dbg !1277
  %31 = icmp eq i32 %30, 0, !dbg !1277
  %is_inf = and i1 %29, %31, !dbg !1277
  %32 = bitcast float %4 to i32, !dbg !1277
  %33 = and i32 %32, 2139095040, !dbg !1277
  %34 = icmp eq i32 %33, 2139095040, !dbg !1277
  %35 = and i32 %32, 8388607, !dbg !1277
  %36 = icmp eq i32 %35, 0, !dbg !1277
  %is_inf4 = and i1 %34, %36, !dbg !1277
  %37 = and i1 %is_inf, %is_inf4, !dbg !1277
  %38 = or i1 %26, %37, !dbg !1277
  %39 = or i1 %21, %38, !dbg !1277
  br i1 %39, label %40, label %42, !dbg !1277

40:                                               ; preds = %if.then
  %41 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1277
  br label %42, !dbg !1277

42:                                               ; preds = %if.then, %40
  %43 = bitcast float %4 to i32, !dbg !1277
  %44 = and i32 %43, 2147483647, !dbg !1277
  %is_zero5 = icmp eq i32 %44, 0, !dbg !1277
  %45 = bitcast float %3 to i32, !dbg !1277
  %46 = and i32 %45, 2139095040, !dbg !1277
  %is_finite = icmp ne i32 %46, 2139095040, !dbg !1277
  %47 = bitcast float %3 to i32, !dbg !1277
  %48 = and i32 %47, 2147483647, !dbg !1277
  %is_zero6 = icmp eq i32 %48, 0, !dbg !1277
  %49 = xor i1 %is_zero6, true, !dbg !1277
  %50 = and i1 %is_finite, %49, !dbg !1277
  %divzero_cond = and i1 %is_zero5, %50, !dbg !1277
  br i1 %divzero_cond, label %51, label %53, !dbg !1277

51:                                               ; preds = %42
  %52 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !1277
  br label %53, !dbg !1277

53:                                               ; preds = %42, %51
  %54 = call float @llvm.nvvm.div.rm.f(float %3, float %4), !dbg !1277
  %55 = bitcast float %3 to i32, !dbg !1278
  %56 = and i32 %55, 2139095040, !dbg !1278
  %is_finite7 = icmp ne i32 %56, 2139095040, !dbg !1278
  %57 = and i1 true, %is_finite7, !dbg !1278
  %58 = bitcast float %4 to i32, !dbg !1278
  %59 = and i32 %58, 2139095040, !dbg !1278
  %is_finite8 = icmp ne i32 %59, 2139095040, !dbg !1278
  %60 = and i1 %57, %is_finite8, !dbg !1278
  %61 = bitcast float %4 to i32, !dbg !1278
  %62 = and i32 %61, 2147483647, !dbg !1278
  %is_zero9 = icmp eq i32 %62, 0, !dbg !1278
  %63 = xor i1 %is_zero9, true, !dbg !1278
  %overflow_denom_nonzero = and i1 %60, %63, !dbg !1278
  %64 = bitcast float %54 to i32, !dbg !1278
  %65 = and i32 %64, 2139095040, !dbg !1278
  %66 = icmp eq i32 %65, 2139095040, !dbg !1278
  %67 = and i32 %64, 8388607, !dbg !1278
  %68 = icmp eq i32 %67, 0, !dbg !1278
  %is_inf10 = and i1 %66, %68, !dbg !1278
  %69 = bitcast float %54 to i32, !dbg !1278
  %70 = and i32 %69, 2147483647, !dbg !1278
  %is_maxfinite = icmp eq i32 %70, 2139095039, !dbg !1278
  %71 = bitcast float %54 to i32, !dbg !1278
  %72 = and i32 %71, -2147483648, !dbg !1278
  %73 = icmp eq i32 %72, 0, !dbg !1278
  %74 = icmp ne i32 %72, 0, !dbg !1278
  %is_pos_inf = and i1 %is_inf10, %73, !dbg !1278
  %is_neg_inf = and i1 %is_inf10, %74, !dbg !1278
  %is_pos_max = and i1 %is_maxfinite, %73, !dbg !1278
  %is_neg_max = and i1 %is_maxfinite, %74, !dbg !1278
  %overflow_rm = or i1 %is_neg_inf, %is_pos_max, !dbg !1278
  %overflow_cond = and i1 %overflow_denom_nonzero, %overflow_rm, !dbg !1278
  br i1 %overflow_cond, label %75, label %77, !dbg !1278

75:                                               ; preds = %53
  %76 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1278
  br label %77, !dbg !1278

77:                                               ; preds = %53, %75
  %78 = bitcast float %3 to i32, !dbg !1278
  %79 = and i32 %78, 2139095040, !dbg !1278
  %80 = icmp eq i32 %79, 0, !dbg !1278
  %81 = and i32 %78, 8388607, !dbg !1278
  %82 = icmp ne i32 %81, 0, !dbg !1278
  %is_subnormal = and i1 %80, %82, !dbg !1278
  %83 = xor i1 %is_subnormal, true, !dbg !1278
  %84 = and i1 true, %83, !dbg !1278
  %85 = bitcast float %4 to i32, !dbg !1278
  %86 = and i32 %85, 2139095040, !dbg !1278
  %87 = icmp eq i32 %86, 0, !dbg !1278
  %88 = and i32 %85, 8388607, !dbg !1278
  %89 = icmp ne i32 %88, 0, !dbg !1278
  %is_subnormal11 = and i1 %87, %89, !dbg !1278
  %90 = xor i1 %is_subnormal11, true, !dbg !1278
  %91 = and i1 %84, %90, !dbg !1278
  %92 = bitcast float %54 to i32, !dbg !1278
  %93 = and i32 %92, 2139095040, !dbg !1278
  %94 = icmp eq i32 %93, 0, !dbg !1278
  %95 = and i32 %92, 8388607, !dbg !1278
  %96 = icmp ne i32 %95, 0, !dbg !1278
  %is_subnormal12 = and i1 %94, %96, !dbg !1278
  %97 = bitcast float %54 to i32, !dbg !1278
  %98 = and i32 %97, 2147483647, !dbg !1278
  %is_zero13 = icmp eq i32 %98, 0, !dbg !1278
  %99 = bitcast float %3 to i32, !dbg !1278
  %100 = and i32 %99, 2147483647, !dbg !1278
  %is_zero14 = icmp eq i32 %100, 0, !dbg !1278
  %101 = xor i1 %is_zero14, true, !dbg !1278
  %102 = bitcast float %4 to i32, !dbg !1278
  %103 = and i32 %102, 2147483647, !dbg !1278
  %is_zero15 = icmp eq i32 %103, 0, !dbg !1278
  %104 = xor i1 %is_zero15, true, !dbg !1278
  %105 = and i1 %101, %104, !dbg !1278
  %106 = and i1 %is_zero13, %105, !dbg !1278
  %is_tiny = or i1 %is_subnormal12, %106, !dbg !1278
  %underflow_cond = and i1 %91, %is_tiny, !dbg !1278
  br i1 %underflow_cond, label %107, label %109, !dbg !1278

107:                                              ; preds = %77
  %108 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1278
  br label %109, !dbg !1278

109:                                              ; preds = %77, %107
  %110 = load ptr, ptr %result.addr, align 8, !dbg !1278
  %arrayidx = getelementptr inbounds float, ptr %110, i64 0, !dbg !1278
  store float %54, ptr %arrayidx, align 4, !dbg !1279
  %111 = load ptr, ptr %result.addr, align 8, !dbg !1280
  %arrayidx2 = getelementptr inbounds float, ptr %111, i64 0, !dbg !1280
  %112 = load float, ptr %arrayidx2, align 4, !dbg !1280
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %112) #4, !dbg !1281
  %113 = zext i1 %call3 to i64, !dbg !1281
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1281
  %114 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1282
  %arrayidx4 = getelementptr inbounds i32, ptr %114, i64 0, !dbg !1282
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1283
  br label %if.end, !dbg !1284

if.end:                                           ; preds = %109, %entry
  %115 = load i32, ptr %idx, align 4, !dbg !1285
  %cmp5 = icmp eq i32 %115, 1, !dbg !1287
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1287

if.then6:                                         ; preds = %if.end
  %116 = load float, ptr %tiny, align 4, !dbg !1288
  %fneg = fneg contract float %116, !dbg !1290
  store float %fneg, ptr %__a.addr.i27, align 4
    #dbg_declare(ptr %__a.addr.i27, !1291, !DIExpression(), !1293)
  store float 5.000000e-01, ptr %__b.addr.i28, align 4
    #dbg_declare(ptr %__b.addr.i28, !1295, !DIExpression(), !1296)
  %117 = load float, ptr %__a.addr.i27, align 4, !dbg !1297
  %118 = load float, ptr %__b.addr.i28, align 4, !dbg !1298
  %119 = bitcast float %117 to i32, !dbg !1299
  %120 = bitcast float %117 to i32, !dbg !1299
  %121 = and i32 %120, 2139095040, !dbg !1299
  %122 = icmp eq i32 %121, 2139095040, !dbg !1299
  %123 = and i32 %120, 8388607, !dbg !1299
  %124 = icmp ne i32 %123, 0, !dbg !1299
  %is_nan16 = and i1 %122, %124, !dbg !1299
  %125 = and i32 %119, 4194304, !dbg !1299
  %126 = icmp eq i32 %125, 0, !dbg !1299
  %is_snan17 = and i1 %is_nan16, %126, !dbg !1299
  %127 = bitcast float %118 to i32, !dbg !1299
  %128 = bitcast float %118 to i32, !dbg !1299
  %129 = and i32 %128, 2139095040, !dbg !1299
  %130 = icmp eq i32 %129, 2139095040, !dbg !1299
  %131 = and i32 %128, 8388607, !dbg !1299
  %132 = icmp ne i32 %131, 0, !dbg !1299
  %is_nan18 = and i1 %130, %132, !dbg !1299
  %133 = and i32 %127, 4194304, !dbg !1299
  %134 = icmp eq i32 %133, 0, !dbg !1299
  %is_snan19 = and i1 %is_nan18, %134, !dbg !1299
  %135 = or i1 %is_snan17, %is_snan19, !dbg !1299
  %136 = bitcast float %117 to i32, !dbg !1299
  %137 = and i32 %136, 2147483647, !dbg !1299
  %is_zero20 = icmp eq i32 %137, 0, !dbg !1299
  %138 = bitcast float %118 to i32, !dbg !1299
  %139 = and i32 %138, 2139095040, !dbg !1299
  %140 = icmp eq i32 %139, 2139095040, !dbg !1299
  %141 = and i32 %138, 8388607, !dbg !1299
  %142 = icmp eq i32 %141, 0, !dbg !1299
  %is_inf21 = and i1 %140, %142, !dbg !1299
  %143 = and i1 %is_zero20, %is_inf21, !dbg !1299
  %144 = bitcast float %117 to i32, !dbg !1299
  %145 = and i32 %144, 2139095040, !dbg !1299
  %146 = icmp eq i32 %145, 2139095040, !dbg !1299
  %147 = and i32 %144, 8388607, !dbg !1299
  %148 = icmp eq i32 %147, 0, !dbg !1299
  %is_inf22 = and i1 %146, %148, !dbg !1299
  %149 = bitcast float %118 to i32, !dbg !1299
  %150 = and i32 %149, 2147483647, !dbg !1299
  %is_zero23 = icmp eq i32 %150, 0, !dbg !1299
  %151 = and i1 %is_inf22, %is_zero23, !dbg !1299
  %152 = or i1 %143, %151, !dbg !1299
  %153 = or i1 %135, %152, !dbg !1299
  br i1 %153, label %154, label %156, !dbg !1299

154:                                              ; preds = %if.then6
  %155 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1299
  br label %156, !dbg !1299

156:                                              ; preds = %if.then6, %154
  %157 = call float @llvm.nvvm.mul.rm.f(float %117, float %118), !dbg !1299
  %158 = bitcast float %117 to i32, !dbg !1300
  %159 = and i32 %158, 2139095040, !dbg !1300
  %is_finite24 = icmp ne i32 %159, 2139095040, !dbg !1300
  %160 = and i1 true, %is_finite24, !dbg !1300
  %161 = bitcast float %118 to i32, !dbg !1300
  %162 = and i32 %161, 2139095040, !dbg !1300
  %is_finite25 = icmp ne i32 %162, 2139095040, !dbg !1300
  %163 = and i1 %160, %is_finite25, !dbg !1300
  %164 = bitcast float %157 to i32, !dbg !1300
  %165 = and i32 %164, 2139095040, !dbg !1300
  %166 = icmp eq i32 %165, 2139095040, !dbg !1300
  %167 = and i32 %164, 8388607, !dbg !1300
  %168 = icmp eq i32 %167, 0, !dbg !1300
  %is_inf26 = and i1 %166, %168, !dbg !1300
  %169 = bitcast float %157 to i32, !dbg !1300
  %170 = and i32 %169, 2147483647, !dbg !1300
  %is_maxfinite27 = icmp eq i32 %170, 2139095039, !dbg !1300
  %171 = bitcast float %157 to i32, !dbg !1300
  %172 = and i32 %171, -2147483648, !dbg !1300
  %173 = icmp eq i32 %172, 0, !dbg !1300
  %174 = icmp ne i32 %172, 0, !dbg !1300
  %is_pos_inf28 = and i1 %is_inf26, %173, !dbg !1300
  %is_neg_inf29 = and i1 %is_inf26, %174, !dbg !1300
  %is_pos_max30 = and i1 %is_maxfinite27, %173, !dbg !1300
  %is_neg_max31 = and i1 %is_maxfinite27, %174, !dbg !1300
  %overflow_rm32 = or i1 %is_neg_inf29, %is_pos_max30, !dbg !1300
  %overflow_cond33 = and i1 %163, %overflow_rm32, !dbg !1300
  br i1 %overflow_cond33, label %175, label %177, !dbg !1300

175:                                              ; preds = %156
  %176 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1300
  br label %177, !dbg !1300

177:                                              ; preds = %156, %175
  %178 = bitcast float %117 to i32, !dbg !1300
  %179 = and i32 %178, 2139095040, !dbg !1300
  %180 = icmp eq i32 %179, 0, !dbg !1300
  %181 = and i32 %178, 8388607, !dbg !1300
  %182 = icmp ne i32 %181, 0, !dbg !1300
  %is_subnormal34 = and i1 %180, %182, !dbg !1300
  %183 = xor i1 %is_subnormal34, true, !dbg !1300
  %184 = and i1 true, %183, !dbg !1300
  %185 = bitcast float %118 to i32, !dbg !1300
  %186 = and i32 %185, 2139095040, !dbg !1300
  %187 = icmp eq i32 %186, 0, !dbg !1300
  %188 = and i32 %185, 8388607, !dbg !1300
  %189 = icmp ne i32 %188, 0, !dbg !1300
  %is_subnormal35 = and i1 %187, %189, !dbg !1300
  %190 = xor i1 %is_subnormal35, true, !dbg !1300
  %191 = and i1 %184, %190, !dbg !1300
  %192 = bitcast float %157 to i32, !dbg !1300
  %193 = and i32 %192, 2139095040, !dbg !1300
  %194 = icmp eq i32 %193, 0, !dbg !1300
  %195 = and i32 %192, 8388607, !dbg !1300
  %196 = icmp ne i32 %195, 0, !dbg !1300
  %is_subnormal36 = and i1 %194, %196, !dbg !1300
  %197 = bitcast float %157 to i32, !dbg !1300
  %198 = and i32 %197, 2147483647, !dbg !1300
  %is_zero37 = icmp eq i32 %198, 0, !dbg !1300
  %199 = bitcast float %117 to i32, !dbg !1300
  %200 = and i32 %199, 2147483647, !dbg !1300
  %is_zero38 = icmp eq i32 %200, 0, !dbg !1300
  %201 = xor i1 %is_zero38, true, !dbg !1300
  %202 = bitcast float %118 to i32, !dbg !1300
  %203 = and i32 %202, 2147483647, !dbg !1300
  %is_zero39 = icmp eq i32 %203, 0, !dbg !1300
  %204 = xor i1 %is_zero39, true, !dbg !1300
  %205 = and i1 %201, %204, !dbg !1300
  %206 = and i1 %is_zero37, %205, !dbg !1300
  %is_tiny40 = or i1 %is_subnormal36, %206, !dbg !1300
  %underflow_cond41 = and i1 %191, %is_tiny40, !dbg !1300
  br i1 %underflow_cond41, label %207, label %209, !dbg !1300

207:                                              ; preds = %177
  %208 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1300
  br label %209, !dbg !1300

209:                                              ; preds = %177, %207
  %210 = load ptr, ptr %result.addr, align 8, !dbg !1300
  %arrayidx8 = getelementptr inbounds float, ptr %210, i64 1, !dbg !1300
  store float %157, ptr %arrayidx8, align 4, !dbg !1301
  %211 = load ptr, ptr %result.addr, align 8, !dbg !1302
  %arrayidx9 = getelementptr inbounds float, ptr %211, i64 1, !dbg !1302
  %212 = load float, ptr %arrayidx9, align 4, !dbg !1302
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %212) #4, !dbg !1303
  %213 = zext i1 %call10 to i64, !dbg !1303
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1303
  %214 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1304
  %arrayidx12 = getelementptr inbounds i32, ptr %214, i64 1, !dbg !1304
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1305
  br label %if.end13, !dbg !1306

if.end13:                                         ; preds = %209, %if.end
  %215 = load i32, ptr %idx, align 4, !dbg !1307
  %cmp14 = icmp eq i32 %215, 2, !dbg !1309
  br i1 %cmp14, label %if.then15, label %if.end23, !dbg !1309

if.then15:                                        ; preds = %if.end13
  %216 = load float, ptr %tiny, align 4, !dbg !1310
  %fneg16 = fneg contract float %216, !dbg !1312
  store float %fneg16, ptr %__a.addr.i24, align 4
    #dbg_declare(ptr %__a.addr.i24, !1291, !DIExpression(), !1313)
  store float 2.500000e-01, ptr %__b.addr.i25, align 4
    #dbg_declare(ptr %__b.addr.i25, !1295, !DIExpression(), !1315)
  %217 = load float, ptr %__a.addr.i24, align 4, !dbg !1316
  %218 = load float, ptr %__b.addr.i25, align 4, !dbg !1317
  %219 = bitcast float %217 to i32, !dbg !1318
  %220 = bitcast float %217 to i32, !dbg !1318
  %221 = and i32 %220, 2139095040, !dbg !1318
  %222 = icmp eq i32 %221, 2139095040, !dbg !1318
  %223 = and i32 %220, 8388607, !dbg !1318
  %224 = icmp ne i32 %223, 0, !dbg !1318
  %is_nan42 = and i1 %222, %224, !dbg !1318
  %225 = and i32 %219, 4194304, !dbg !1318
  %226 = icmp eq i32 %225, 0, !dbg !1318
  %is_snan43 = and i1 %is_nan42, %226, !dbg !1318
  %227 = bitcast float %218 to i32, !dbg !1318
  %228 = bitcast float %218 to i32, !dbg !1318
  %229 = and i32 %228, 2139095040, !dbg !1318
  %230 = icmp eq i32 %229, 2139095040, !dbg !1318
  %231 = and i32 %228, 8388607, !dbg !1318
  %232 = icmp ne i32 %231, 0, !dbg !1318
  %is_nan44 = and i1 %230, %232, !dbg !1318
  %233 = and i32 %227, 4194304, !dbg !1318
  %234 = icmp eq i32 %233, 0, !dbg !1318
  %is_snan45 = and i1 %is_nan44, %234, !dbg !1318
  %235 = or i1 %is_snan43, %is_snan45, !dbg !1318
  %236 = bitcast float %217 to i32, !dbg !1318
  %237 = and i32 %236, 2147483647, !dbg !1318
  %is_zero46 = icmp eq i32 %237, 0, !dbg !1318
  %238 = bitcast float %218 to i32, !dbg !1318
  %239 = and i32 %238, 2139095040, !dbg !1318
  %240 = icmp eq i32 %239, 2139095040, !dbg !1318
  %241 = and i32 %238, 8388607, !dbg !1318
  %242 = icmp eq i32 %241, 0, !dbg !1318
  %is_inf47 = and i1 %240, %242, !dbg !1318
  %243 = and i1 %is_zero46, %is_inf47, !dbg !1318
  %244 = bitcast float %217 to i32, !dbg !1318
  %245 = and i32 %244, 2139095040, !dbg !1318
  %246 = icmp eq i32 %245, 2139095040, !dbg !1318
  %247 = and i32 %244, 8388607, !dbg !1318
  %248 = icmp eq i32 %247, 0, !dbg !1318
  %is_inf48 = and i1 %246, %248, !dbg !1318
  %249 = bitcast float %218 to i32, !dbg !1318
  %250 = and i32 %249, 2147483647, !dbg !1318
  %is_zero49 = icmp eq i32 %250, 0, !dbg !1318
  %251 = and i1 %is_inf48, %is_zero49, !dbg !1318
  %252 = or i1 %243, %251, !dbg !1318
  %253 = or i1 %235, %252, !dbg !1318
  br i1 %253, label %254, label %256, !dbg !1318

254:                                              ; preds = %if.then15
  %255 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1318
  br label %256, !dbg !1318

256:                                              ; preds = %if.then15, %254
  %257 = call float @llvm.nvvm.mul.rm.f(float %217, float %218), !dbg !1318
  %258 = bitcast float %217 to i32, !dbg !1319
  %259 = and i32 %258, 2139095040, !dbg !1319
  %is_finite50 = icmp ne i32 %259, 2139095040, !dbg !1319
  %260 = and i1 true, %is_finite50, !dbg !1319
  %261 = bitcast float %218 to i32, !dbg !1319
  %262 = and i32 %261, 2139095040, !dbg !1319
  %is_finite51 = icmp ne i32 %262, 2139095040, !dbg !1319
  %263 = and i1 %260, %is_finite51, !dbg !1319
  %264 = bitcast float %257 to i32, !dbg !1319
  %265 = and i32 %264, 2139095040, !dbg !1319
  %266 = icmp eq i32 %265, 2139095040, !dbg !1319
  %267 = and i32 %264, 8388607, !dbg !1319
  %268 = icmp eq i32 %267, 0, !dbg !1319
  %is_inf52 = and i1 %266, %268, !dbg !1319
  %269 = bitcast float %257 to i32, !dbg !1319
  %270 = and i32 %269, 2147483647, !dbg !1319
  %is_maxfinite53 = icmp eq i32 %270, 2139095039, !dbg !1319
  %271 = bitcast float %257 to i32, !dbg !1319
  %272 = and i32 %271, -2147483648, !dbg !1319
  %273 = icmp eq i32 %272, 0, !dbg !1319
  %274 = icmp ne i32 %272, 0, !dbg !1319
  %is_pos_inf54 = and i1 %is_inf52, %273, !dbg !1319
  %is_neg_inf55 = and i1 %is_inf52, %274, !dbg !1319
  %is_pos_max56 = and i1 %is_maxfinite53, %273, !dbg !1319
  %is_neg_max57 = and i1 %is_maxfinite53, %274, !dbg !1319
  %overflow_rm58 = or i1 %is_neg_inf55, %is_pos_max56, !dbg !1319
  %overflow_cond59 = and i1 %263, %overflow_rm58, !dbg !1319
  br i1 %overflow_cond59, label %275, label %277, !dbg !1319

275:                                              ; preds = %256
  %276 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1319
  br label %277, !dbg !1319

277:                                              ; preds = %256, %275
  %278 = bitcast float %217 to i32, !dbg !1319
  %279 = and i32 %278, 2139095040, !dbg !1319
  %280 = icmp eq i32 %279, 0, !dbg !1319
  %281 = and i32 %278, 8388607, !dbg !1319
  %282 = icmp ne i32 %281, 0, !dbg !1319
  %is_subnormal60 = and i1 %280, %282, !dbg !1319
  %283 = xor i1 %is_subnormal60, true, !dbg !1319
  %284 = and i1 true, %283, !dbg !1319
  %285 = bitcast float %218 to i32, !dbg !1319
  %286 = and i32 %285, 2139095040, !dbg !1319
  %287 = icmp eq i32 %286, 0, !dbg !1319
  %288 = and i32 %285, 8388607, !dbg !1319
  %289 = icmp ne i32 %288, 0, !dbg !1319
  %is_subnormal61 = and i1 %287, %289, !dbg !1319
  %290 = xor i1 %is_subnormal61, true, !dbg !1319
  %291 = and i1 %284, %290, !dbg !1319
  %292 = bitcast float %257 to i32, !dbg !1319
  %293 = and i32 %292, 2139095040, !dbg !1319
  %294 = icmp eq i32 %293, 0, !dbg !1319
  %295 = and i32 %292, 8388607, !dbg !1319
  %296 = icmp ne i32 %295, 0, !dbg !1319
  %is_subnormal62 = and i1 %294, %296, !dbg !1319
  %297 = bitcast float %257 to i32, !dbg !1319
  %298 = and i32 %297, 2147483647, !dbg !1319
  %is_zero63 = icmp eq i32 %298, 0, !dbg !1319
  %299 = bitcast float %217 to i32, !dbg !1319
  %300 = and i32 %299, 2147483647, !dbg !1319
  %is_zero64 = icmp eq i32 %300, 0, !dbg !1319
  %301 = xor i1 %is_zero64, true, !dbg !1319
  %302 = bitcast float %218 to i32, !dbg !1319
  %303 = and i32 %302, 2147483647, !dbg !1319
  %is_zero65 = icmp eq i32 %303, 0, !dbg !1319
  %304 = xor i1 %is_zero65, true, !dbg !1319
  %305 = and i1 %301, %304, !dbg !1319
  %306 = and i1 %is_zero63, %305, !dbg !1319
  %is_tiny66 = or i1 %is_subnormal62, %306, !dbg !1319
  %underflow_cond67 = and i1 %291, %is_tiny66, !dbg !1319
  br i1 %underflow_cond67, label %307, label %309, !dbg !1319

307:                                              ; preds = %277
  %308 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1319
  br label %309, !dbg !1319

309:                                              ; preds = %277, %307
  %310 = load ptr, ptr %result.addr, align 8, !dbg !1319
  %arrayidx18 = getelementptr inbounds float, ptr %310, i64 2, !dbg !1319
  store float %257, ptr %arrayidx18, align 4, !dbg !1320
  %311 = load ptr, ptr %result.addr, align 8, !dbg !1321
  %arrayidx19 = getelementptr inbounds float, ptr %311, i64 2, !dbg !1321
  %312 = load float, ptr %arrayidx19, align 4, !dbg !1321
  %call20 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %312) #4, !dbg !1322
  %313 = zext i1 %call20 to i64, !dbg !1322
  %cond21 = select i1 %call20, i32 1, i32 0, !dbg !1322
  %314 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1323
  %arrayidx22 = getelementptr inbounds i32, ptr %314, i64 2, !dbg !1323
  store i32 %cond21, ptr %arrayidx22, align 4, !dbg !1324
  br label %if.end23, !dbg !1325

if.end23:                                         ; preds = %309, %if.end13
  ret void, !dbg !1326
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rm.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rm.f(float, float) #1

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { convergent nounwind }
attributes #5 = { nounwind memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!954, !955}
!nvvmir.version = !{!956}
!llvm.module.flags = !{!957, !958, !959, !960, !961, !962}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/underflow/rounding.cu", directory: "/home/users/sislam3/SBAC-PAD")
!2 = !{!3}
!3 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "sm_selector", scope: !5, file: !4, line: 84, baseType: !8, size: 64, flags: DIFlagEnumClass, elements: !10, identifier: "_ZTSN2nv6target6detail11sm_selectorE")
!4 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/nv/target", directory: "")
!5 = !DINamespace(name: "detail", scope: !6)
!6 = !DINamespace(name: "target", scope: !7)
!7 = !DINamespace(name: "nv", scope: null)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "base_int_t", scope: !5, file: !4, line: 47, baseType: !9)
!9 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!10 = !{!11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26}
!11 = !DIEnumerator(name: "sm_35", value: 35, isUnsigned: true)
!12 = !DIEnumerator(name: "sm_37", value: 37, isUnsigned: true)
!13 = !DIEnumerator(name: "sm_50", value: 50, isUnsigned: true)
!14 = !DIEnumerator(name: "sm_52", value: 52, isUnsigned: true)
!15 = !DIEnumerator(name: "sm_53", value: 53, isUnsigned: true)
!16 = !DIEnumerator(name: "sm_60", value: 60, isUnsigned: true)
!17 = !DIEnumerator(name: "sm_61", value: 61, isUnsigned: true)
!18 = !DIEnumerator(name: "sm_62", value: 62, isUnsigned: true)
!19 = !DIEnumerator(name: "sm_70", value: 70, isUnsigned: true)
!20 = !DIEnumerator(name: "sm_72", value: 72, isUnsigned: true)
!21 = !DIEnumerator(name: "sm_75", value: 75, isUnsigned: true)
!22 = !DIEnumerator(name: "sm_80", value: 80, isUnsigned: true)
!23 = !DIEnumerator(name: "sm_86", value: 86, isUnsigned: true)
!24 = !DIEnumerator(name: "sm_87", value: 87, isUnsigned: true)
!25 = !DIEnumerator(name: "sm_89", value: 89, isUnsigned: true)
!26 = !DIEnumerator(name: "sm_90", value: 90, isUnsigned: true)
!27 = !{!28, !35, !60}
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "target_description", scope: !5, file: !4, line: 74, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !29, identifier: "_ZTSN2nv6target6detail18target_descriptionE")
!29 = !{!30, !31}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "targets", scope: !28, file: !4, line: 76, baseType: !8, size: 64)
!31 = !DISubprogram(name: "target_description", linkageName: "_ZN2nv6target6detail18target_descriptionC4Ey", scope: !28, file: !4, line: 78, type: !32, scopeLine: 78, flags: DIFlagPrototyped, spFlags: 0)
!32 = !DISubroutineType(types: !33)
!33 = !{null, !34, !8}
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "dim3", file: !36, line: 426, size: 96, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !37, identifier: "_ZTS4dim3")
!36 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/vector_types.h", directory: "")
!37 = !{!38, !40, !41, !42, !46, !55}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !36, line: 428, baseType: !39, size: 32)
!39 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 32)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 64)
!42 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4Ejjj", scope: !35, file: !36, line: 431, type: !43, scopeLine: 431, flags: DIFlagPrototyped, spFlags: 0)
!43 = !DISubroutineType(types: !44)
!44 = !{null, !45, !39, !39, !39}
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!46 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4E5uint3", scope: !35, file: !36, line: 432, type: !47, scopeLine: 432, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !45, !49}
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint3", file: !36, line: 388, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "uint3", file: !36, line: 196, size: 96, flags: DIFlagTypePassByValue, elements: !51, identifier: "_ZTS5uint3")
!51 = !{!52, !53, !54}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !50, file: !36, line: 198, baseType: !39, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 64)
!55 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK4dim3cv5uint3Ev", scope: !35, file: !36, line: 433, type: !56, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!49, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__cuda_builtin_threadIdx_t", file: !61, line: 52, size: 8, flags: DIFlagTypePassByReference, elements: !62, identifier: "_ZTS26__cuda_builtin_threadIdx_t")
!61 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_builtin_vars.h", directory: "")
!62 = !{!63, !66, !67, !68, !73, !76, !80, !84, !87}
!63 = !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!64 = !DISubroutineType(types: !65)
!65 = !{!39}
!66 = !DISubprogram(name: "__fetch_builtin_y", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_yEv", scope: !60, file: !61, line: 54, type: !64, scopeLine: 54, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!67 = !DISubprogram(name: "__fetch_builtin_z", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_zEv", scope: !60, file: !61, line: 55, type: !64, scopeLine: 55, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!68 = !DISubprogram(name: "operator dim3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv4dim3Ev", scope: !60, file: !61, line: 58, type: !69, scopeLine: 58, flags: DIFlagPrototyped, spFlags: 0)
!69 = !DISubroutineType(types: !70)
!70 = !{!35, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !60)
!73 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv5uint3Ev", scope: !60, file: !61, line: 59, type: !74, scopeLine: 59, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{!50, !71}
!76 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4Ev", scope: !60, file: !61, line: 62, type: !77, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!77 = !DISubroutineType(types: !78)
!78 = !{null, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!80 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4ERKS_", scope: !60, file: !61, line: 62, type: !81, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !79, !83}
!83 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !72, size: 64)
!84 = !DISubprogram(name: "operator=", linkageName: "_ZNK26__cuda_builtin_threadIdx_taSERKS_", scope: !60, file: !61, line: 62, type: !85, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !71, !83}
!87 = !DISubprogram(name: "operator&", linkageName: "_ZNK26__cuda_builtin_threadIdx_tadEv", scope: !60, file: !61, line: 62, type: !88, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!88 = !DISubroutineType(types: !89)
!89 = !{!90, !71}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !295, !297, !299, !303, !305, !307, !309, !311, !313, !315, !317, !321, !325, !327, !329, !334, !336, !338, !340, !342, !344, !346, !349, !351, !353, !355, !360, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !386, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !420, !422, !426, !428, !430, !432, !434, !436, !438, !440, !442, !444, !448, !450, !454, !456, !458, !460, !464, !466, !470, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !498, !500, !504, !506, !508, !510, !512, !514, !518, !520, !522, !524, !526, !528, !530, !534, !538, !540, !542, !544, !546, !550, !552, !556, !558, !560, !562, !564, !566, !568, !572, !574, !578, !580, !582, !586, !588, !590, !592, !594, !596, !598, !602, !606, !612, !616, !624, !629, !631, !633, !637, !641, !651, !653, !657, !661, !665, !670, !672, !676, !680, !684, !692, !696, !700, !702, !706, !710, !714, !720, !724, !728, !730, !738, !742, !749, !751, !753, !757, !761, !765, !769, !773, !777, !778, !779, !780, !782, !783, !784, !785, !786, !787, !788, !790, !791, !792, !793, !794, !795, !796, !797, !802, !803, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !830, !832, !834, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !860, !862, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945, !947, !949}
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !94, file: !95, line: 200)
!93 = !DINamespace(name: "std", scope: null)
!94 = !DISubprogram(name: "abs", linkageName: "_ZL3absi", scope: !95, file: !95, line: 30, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!95 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math_forward_declares.h", directory: "")
!96 = !DISubroutineType(types: !97)
!97 = !{!98, !98}
!98 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !100, file: !95, line: 201)
!100 = !DISubprogram(name: "acos", linkageName: "_ZL4acosf", scope: !95, file: !95, line: 32, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!101 = !DISubroutineType(types: !102)
!102 = !{!103, !103}
!103 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !105, file: !95, line: 202)
!105 = !DISubprogram(name: "acosh", linkageName: "_ZL5acoshf", scope: !95, file: !95, line: 34, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !107, file: !95, line: 203)
!107 = !DISubprogram(name: "asin", linkageName: "_ZL4asinf", scope: !95, file: !95, line: 36, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !109, file: !95, line: 204)
!109 = !DISubprogram(name: "asinh", linkageName: "_ZL5asinhf", scope: !95, file: !95, line: 38, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !111, file: !95, line: 205)
!111 = !DISubprogram(name: "atan", linkageName: "_ZL4atanf", scope: !95, file: !95, line: 42, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !113, file: !95, line: 206)
!113 = !DISubprogram(name: "atan2", linkageName: "_ZL5atan2ff", scope: !95, file: !95, line: 40, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!114 = !DISubroutineType(types: !115)
!115 = !{!103, !103, !103}
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !117, file: !95, line: 207)
!117 = !DISubprogram(name: "atanh", linkageName: "_ZL5atanhf", scope: !95, file: !95, line: 44, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !119, file: !95, line: 208)
!119 = !DISubprogram(name: "cbrt", linkageName: "_ZL4cbrtf", scope: !95, file: !95, line: 46, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !121, file: !95, line: 209)
!121 = !DISubprogram(name: "ceil", linkageName: "_ZL4ceilf", scope: !95, file: !95, line: 48, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !123, file: !95, line: 210)
!123 = !DISubprogram(name: "copysign", linkageName: "_ZL8copysignff", scope: !95, file: !95, line: 50, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !125, file: !95, line: 211)
!125 = !DISubprogram(name: "cos", linkageName: "_ZL3cosf", scope: !95, file: !95, line: 52, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !127, file: !95, line: 212)
!127 = !DISubprogram(name: "cosh", linkageName: "_ZL4coshf", scope: !95, file: !95, line: 54, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !129, file: !95, line: 213)
!129 = !DISubprogram(name: "erf", linkageName: "_ZL3erff", scope: !95, file: !95, line: 58, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !131, file: !95, line: 214)
!131 = !DISubprogram(name: "erfc", linkageName: "_ZL4erfcf", scope: !95, file: !95, line: 56, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !133, file: !95, line: 215)
!133 = !DISubprogram(name: "exp", linkageName: "_ZL3expf", scope: !95, file: !95, line: 62, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !135, file: !95, line: 216)
!135 = !DISubprogram(name: "exp2", linkageName: "_ZL4exp2f", scope: !95, file: !95, line: 60, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !137, file: !95, line: 217)
!137 = !DISubprogram(name: "expm1", linkageName: "_ZL5expm1f", scope: !95, file: !95, line: 64, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !139, file: !95, line: 218)
!139 = !DISubprogram(name: "fabs", linkageName: "_ZL4fabsf", scope: !95, file: !95, line: 66, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !141, file: !95, line: 219)
!141 = !DISubprogram(name: "fdim", linkageName: "_ZL4fdimff", scope: !95, file: !95, line: 68, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !143, file: !95, line: 220)
!143 = !DISubprogram(name: "floor", linkageName: "_ZL5floorf", scope: !95, file: !95, line: 70, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !145, file: !95, line: 221)
!145 = !DISubprogram(name: "fma", linkageName: "_ZL3fmafff", scope: !95, file: !95, line: 72, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!146 = !DISubroutineType(types: !147)
!147 = !{!103, !103, !103, !103}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !149, file: !95, line: 222)
!149 = !DISubprogram(name: "fmax", linkageName: "_ZL4fmaxff", scope: !95, file: !95, line: 74, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !151, file: !95, line: 223)
!151 = !DISubprogram(name: "fmin", linkageName: "_ZL4fminff", scope: !95, file: !95, line: 76, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !153, file: !95, line: 224)
!153 = !DISubprogram(name: "fmod", linkageName: "_ZL4fmodff", scope: !95, file: !95, line: 78, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !155, file: !95, line: 225)
!155 = !DISubprogram(name: "fpclassify", linkageName: "_ZL10fpclassifyf", scope: !95, file: !95, line: 80, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!156 = !DISubroutineType(types: !157)
!157 = !{!98, !103}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !159, file: !95, line: 226)
!159 = !DISubprogram(name: "frexp", linkageName: "_ZL5frexpfPi", scope: !95, file: !95, line: 82, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!160 = !DISubroutineType(types: !161)
!161 = !{!103, !103, !162}
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!163 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !164, file: !95, line: 227)
!164 = !DISubprogram(name: "hypot", linkageName: "_ZL5hypotff", scope: !95, file: !95, line: 84, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !166, file: !95, line: 228)
!166 = !DISubprogram(name: "ilogb", linkageName: "_ZL5ilogbf", scope: !95, file: !95, line: 86, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !168, file: !95, line: 229)
!168 = !DISubprogram(name: "isfinite", linkageName: "_ZL8isfinitef", scope: !95, file: !95, line: 91, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!169 = !DISubroutineType(types: !170)
!170 = !{!171, !103}
!171 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !173, file: !95, line: 230)
!173 = !DISubprogram(name: "isgreater", linkageName: "_ZL9isgreaterff", scope: !95, file: !95, line: 95, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!174 = !DISubroutineType(types: !175)
!175 = !{!171, !103, !103}
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !177, file: !95, line: 231)
!177 = !DISubprogram(name: "isgreaterequal", linkageName: "_ZL14isgreaterequalff", scope: !95, file: !95, line: 94, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !179, file: !95, line: 232)
!179 = !DISubprogram(name: "isinf", linkageName: "_ZL5isinff", scope: !95, file: !95, line: 100, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !181, file: !95, line: 233)
!181 = !DISubprogram(name: "isless", linkageName: "_ZL6islessff", scope: !95, file: !95, line: 104, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !183, file: !95, line: 234)
!183 = !DISubprogram(name: "islessequal", linkageName: "_ZL11islessequalff", scope: !95, file: !95, line: 103, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !185, file: !95, line: 235)
!185 = !DISubprogram(name: "islessgreater", linkageName: "_ZL13islessgreaterff", scope: !95, file: !95, line: 106, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !187, file: !95, line: 236)
!187 = !DISubprogram(name: "isnan", linkageName: "_ZL5isnanf", scope: !95, file: !95, line: 111, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !189, file: !95, line: 237)
!189 = !DISubprogram(name: "isnormal", linkageName: "_ZL8isnormalf", scope: !95, file: !95, line: 113, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !191, file: !95, line: 238)
!191 = !DISubprogram(name: "isunordered", linkageName: "_ZL11isunorderedff", scope: !95, file: !95, line: 115, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !193, file: !95, line: 239)
!193 = !DISubprogram(name: "labs", linkageName: "_ZL4labsl", scope: !95, file: !95, line: 116, type: !194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!194 = !DISubroutineType(types: !195)
!195 = !{!196, !196}
!196 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !198, file: !95, line: 240)
!198 = !DISubprogram(name: "ldexp", linkageName: "_ZL5ldexpfi", scope: !95, file: !95, line: 118, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!199 = !DISubroutineType(types: !200)
!200 = !{!103, !103, !98}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !202, file: !95, line: 241)
!202 = !DISubprogram(name: "lgamma", linkageName: "_ZL6lgammaf", scope: !95, file: !95, line: 120, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !204, file: !95, line: 242)
!204 = !DISubprogram(name: "llabs", linkageName: "_ZL5llabsx", scope: !95, file: !95, line: 121, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!205 = !DISubroutineType(types: !206)
!206 = !{!207, !207}
!207 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !209, file: !95, line: 243)
!209 = !DISubprogram(name: "llrint", linkageName: "_ZL6llrintf", scope: !95, file: !95, line: 123, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!210 = !DISubroutineType(types: !211)
!211 = !{!207, !103}
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !213, file: !95, line: 244)
!213 = !DISubprogram(name: "log", linkageName: "_ZL3logf", scope: !95, file: !95, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !215, file: !95, line: 245)
!215 = !DISubprogram(name: "log10", linkageName: "_ZL5log10f", scope: !95, file: !95, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !217, file: !95, line: 246)
!217 = !DISubprogram(name: "log1p", linkageName: "_ZL5log1pf", scope: !95, file: !95, line: 127, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !219, file: !95, line: 247)
!219 = !DISubprogram(name: "log2", linkageName: "_ZL4log2f", scope: !95, file: !95, line: 129, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !221, file: !95, line: 248)
!221 = !DISubprogram(name: "logb", linkageName: "_ZL4logbf", scope: !95, file: !95, line: 131, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !223, file: !95, line: 249)
!223 = !DISubprogram(name: "lrint", linkageName: "_ZL5lrintf", scope: !95, file: !95, line: 135, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!224 = !DISubroutineType(types: !225)
!225 = !{!196, !103}
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !227, file: !95, line: 250)
!227 = !DISubprogram(name: "lround", linkageName: "_ZL6lroundf", scope: !95, file: !95, line: 137, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !229, file: !95, line: 251)
!229 = !DISubprogram(name: "llround", linkageName: "_ZL7llroundf", scope: !95, file: !95, line: 138, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !231, file: !95, line: 252)
!231 = !DISubprogram(name: "modf", linkageName: "_ZL4modffPf", scope: !95, file: !95, line: 140, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!232 = !DISubroutineType(types: !233)
!233 = !{!103, !103, !234}
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !236, file: !95, line: 253)
!236 = !DISubprogram(name: "nan", linkageName: "_ZL3nanPKc", scope: !95, file: !95, line: 141, type: !237, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!237 = !DISubroutineType(types: !238)
!238 = !{!239, !240}
!239 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!240 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !241, size: 64)
!241 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !242)
!242 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !244, file: !95, line: 254)
!244 = !DISubprogram(name: "nanf", linkageName: "_ZL4nanfPKc", scope: !95, file: !95, line: 142, type: !245, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!245 = !DISubroutineType(types: !246)
!246 = !{!103, !240}
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !248, file: !95, line: 255)
!248 = !DISubprogram(name: "nearbyint", linkageName: "_ZL9nearbyintf", scope: !95, file: !95, line: 144, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !250, file: !95, line: 256)
!250 = !DISubprogram(name: "nextafter", linkageName: "_ZL9nextafterff", scope: !95, file: !95, line: 146, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !252, file: !95, line: 257)
!252 = !DISubprogram(name: "pow", linkageName: "_ZL3powfi", scope: !95, file: !95, line: 150, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !254, file: !95, line: 258)
!254 = !DISubprogram(name: "remainder", linkageName: "_ZL9remainderff", scope: !95, file: !95, line: 152, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !256, file: !95, line: 259)
!256 = !DISubprogram(name: "remquo", linkageName: "_ZL6remquoffPi", scope: !95, file: !95, line: 154, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!257 = !DISubroutineType(types: !258)
!258 = !{!103, !103, !103, !162}
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !260, file: !95, line: 260)
!260 = !DISubprogram(name: "rint", linkageName: "_ZL4rintf", scope: !95, file: !95, line: 156, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !262, file: !95, line: 261)
!262 = !DISubprogram(name: "round", linkageName: "_ZL5roundf", scope: !95, file: !95, line: 158, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !264, file: !95, line: 262)
!264 = !DISubprogram(name: "scalbln", linkageName: "_ZL7scalblnfl", scope: !95, file: !95, line: 160, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!265 = !DISubroutineType(types: !266)
!266 = !{!103, !103, !196}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !268, file: !95, line: 263)
!268 = !DISubprogram(name: "scalbn", linkageName: "_ZL6scalbnfi", scope: !95, file: !95, line: 162, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !270, file: !95, line: 264)
!270 = !DISubprogram(name: "signbit", linkageName: "_ZL7signbitf", scope: !95, file: !95, line: 167, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !272, file: !95, line: 265)
!272 = !DISubprogram(name: "sin", linkageName: "_ZL3sinf", scope: !95, file: !95, line: 169, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !274, file: !95, line: 266)
!274 = !DISubprogram(name: "sinh", linkageName: "_ZL4sinhf", scope: !95, file: !95, line: 171, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !276, file: !95, line: 267)
!276 = !DISubprogram(name: "sqrt", linkageName: "_ZL4sqrtf", scope: !95, file: !95, line: 173, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !278, file: !95, line: 268)
!278 = !DISubprogram(name: "tan", linkageName: "_ZL3tanf", scope: !95, file: !95, line: 175, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !280, file: !95, line: 269)
!280 = !DISubprogram(name: "tanh", linkageName: "_ZL4tanhf", scope: !95, file: !95, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !282, file: !95, line: 270)
!282 = !DISubprogram(name: "tgamma", linkageName: "_ZL6tgammaf", scope: !95, file: !95, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !284, file: !95, line: 271)
!284 = !DISubprogram(name: "trunc", linkageName: "_ZL5truncf", scope: !95, file: !95, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !286, file: !288, line: 52)
!286 = !DISubprogram(name: "abs", scope: !287, file: !287, line: 837, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!288 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !290, file: !294, line: 85)
!290 = !DISubprogram(name: "acos", scope: !291, file: !291, line: 53, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!291 = !DIFile(filename: "/usr/include/bits/mathcalls.h", directory: "")
!292 = !DISubroutineType(types: !293)
!293 = !{!239, !239}
!294 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cmath", directory: "")
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !296, file: !294, line: 104)
!296 = !DISubprogram(name: "asin", scope: !291, file: !291, line: 55, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !298, file: !294, line: 123)
!298 = !DISubprogram(name: "atan", scope: !291, file: !291, line: 57, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !300, file: !294, line: 142)
!300 = !DISubprogram(name: "atan2", scope: !291, file: !291, line: 59, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DISubroutineType(types: !302)
!302 = !{!239, !239, !239}
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !304, file: !294, line: 154)
!304 = !DISubprogram(name: "ceil", scope: !291, file: !291, line: 159, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !306, file: !294, line: 173)
!306 = !DISubprogram(name: "cos", scope: !291, file: !291, line: 62, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !308, file: !294, line: 192)
!308 = !DISubprogram(name: "cosh", scope: !291, file: !291, line: 71, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !310, file: !294, line: 211)
!310 = !DISubprogram(name: "exp", scope: !291, file: !291, line: 95, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !312, file: !294, line: 230)
!312 = !DISubprogram(name: "fabs", scope: !291, file: !291, line: 162, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !314, file: !294, line: 249)
!314 = !DISubprogram(name: "floor", scope: !291, file: !291, line: 165, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !316, file: !294, line: 268)
!316 = !DISubprogram(name: "fmod", scope: !291, file: !291, line: 168, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !318, file: !294, line: 280)
!318 = !DISubprogram(name: "frexp", scope: !291, file: !291, line: 98, type: !319, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DISubroutineType(types: !320)
!320 = !{!239, !239, !162}
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !322, file: !294, line: 299)
!322 = !DISubprogram(name: "ldexp", scope: !291, file: !291, line: 101, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!323 = !DISubroutineType(types: !324)
!324 = !{!239, !239, !98}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !326, file: !294, line: 318)
!326 = !DISubprogram(name: "log", scope: !291, file: !291, line: 104, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !328, file: !294, line: 337)
!328 = !DISubprogram(name: "log10", scope: !291, file: !291, line: 107, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !330, file: !294, line: 356)
!330 = !DISubprogram(name: "modf", scope: !291, file: !291, line: 110, type: !331, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DISubroutineType(types: !332)
!332 = !{!239, !239, !333}
!333 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !335, file: !294, line: 368)
!335 = !DISubprogram(name: "pow", scope: !291, file: !291, line: 140, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !337, file: !294, line: 396)
!337 = !DISubprogram(name: "sin", scope: !291, file: !291, line: 64, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !339, file: !294, line: 415)
!339 = !DISubprogram(name: "sinh", scope: !291, file: !291, line: 73, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !341, file: !294, line: 434)
!341 = !DISubprogram(name: "sqrt", scope: !291, file: !291, line: 143, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !343, file: !294, line: 453)
!343 = !DISubprogram(name: "tan", scope: !291, file: !291, line: 66, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !345, file: !294, line: 472)
!345 = !DISubprogram(name: "tanh", scope: !291, file: !291, line: 75, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !347, file: !294, line: 1881)
!347 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !348, line: 150, baseType: !239)
!348 = !DIFile(filename: "/usr/include/math.h", directory: "")
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !350, file: !294, line: 1882)
!350 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !348, line: 149, baseType: !103)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !352, file: !294, line: 1885)
!352 = !DISubprogram(name: "acosh", scope: !291, file: !291, line: 85, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !354, file: !294, line: 1886)
!354 = !DISubprogram(name: "acoshf", scope: !291, file: !291, line: 85, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !356, file: !294, line: 1887)
!356 = !DISubprogram(name: "acoshl", scope: !291, file: !291, line: 85, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!357 = !DISubroutineType(types: !358)
!358 = !{!359, !359}
!359 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !361, file: !294, line: 1889)
!361 = !DISubprogram(name: "asinh", scope: !291, file: !291, line: 87, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !363, file: !294, line: 1890)
!363 = !DISubprogram(name: "asinhf", scope: !291, file: !291, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !365, file: !294, line: 1891)
!365 = !DISubprogram(name: "asinhl", scope: !291, file: !291, line: 87, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !367, file: !294, line: 1893)
!367 = !DISubprogram(name: "atanh", scope: !291, file: !291, line: 89, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !369, file: !294, line: 1894)
!369 = !DISubprogram(name: "atanhf", scope: !291, file: !291, line: 89, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !371, file: !294, line: 1895)
!371 = !DISubprogram(name: "atanhl", scope: !291, file: !291, line: 89, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !373, file: !294, line: 1897)
!373 = !DISubprogram(name: "cbrt", scope: !291, file: !291, line: 152, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !375, file: !294, line: 1898)
!375 = !DISubprogram(name: "cbrtf", scope: !291, file: !291, line: 152, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !377, file: !294, line: 1899)
!377 = !DISubprogram(name: "cbrtl", scope: !291, file: !291, line: 152, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !379, file: !294, line: 1901)
!379 = !DISubprogram(name: "copysign", scope: !291, file: !291, line: 196, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !381, file: !294, line: 1902)
!381 = !DISubprogram(name: "copysignf", scope: !291, file: !291, line: 196, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !383, file: !294, line: 1903)
!383 = !DISubprogram(name: "copysignl", scope: !291, file: !291, line: 196, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DISubroutineType(types: !385)
!385 = !{!359, !359, !359}
!386 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !387, file: !294, line: 1905)
!387 = !DISubprogram(name: "erf", scope: !291, file: !291, line: 228, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !389, file: !294, line: 1906)
!389 = !DISubprogram(name: "erff", scope: !291, file: !291, line: 228, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !391, file: !294, line: 1907)
!391 = !DISubprogram(name: "erfl", scope: !291, file: !291, line: 228, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !393, file: !294, line: 1909)
!393 = !DISubprogram(name: "erfc", scope: !291, file: !291, line: 229, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !395, file: !294, line: 1910)
!395 = !DISubprogram(name: "erfcf", scope: !291, file: !291, line: 229, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !397, file: !294, line: 1911)
!397 = !DISubprogram(name: "erfcl", scope: !291, file: !291, line: 229, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !399, file: !294, line: 1913)
!399 = !DISubprogram(name: "exp2", scope: !291, file: !291, line: 130, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !401, file: !294, line: 1914)
!401 = !DISubprogram(name: "exp2f", scope: !291, file: !291, line: 130, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !403, file: !294, line: 1915)
!403 = !DISubprogram(name: "exp2l", scope: !291, file: !291, line: 130, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !405, file: !294, line: 1917)
!405 = !DISubprogram(name: "expm1", scope: !291, file: !291, line: 119, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !407, file: !294, line: 1918)
!407 = !DISubprogram(name: "expm1f", scope: !291, file: !291, line: 119, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !409, file: !294, line: 1919)
!409 = !DISubprogram(name: "expm1l", scope: !291, file: !291, line: 119, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !411, file: !294, line: 1921)
!411 = !DISubprogram(name: "fdim", scope: !291, file: !291, line: 326, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !413, file: !294, line: 1922)
!413 = !DISubprogram(name: "fdimf", scope: !291, file: !291, line: 326, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !415, file: !294, line: 1923)
!415 = !DISubprogram(name: "fdiml", scope: !291, file: !291, line: 326, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !417, file: !294, line: 1925)
!417 = !DISubprogram(name: "fma", scope: !291, file: !291, line: 335, type: !418, flags: DIFlagPrototyped, spFlags: 0)
!418 = !DISubroutineType(types: !419)
!419 = !{!239, !239, !239, !239}
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !421, file: !294, line: 1926)
!421 = !DISubprogram(name: "fmaf", scope: !291, file: !291, line: 335, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !423, file: !294, line: 1927)
!423 = !DISubprogram(name: "fmal", scope: !291, file: !291, line: 335, type: !424, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DISubroutineType(types: !425)
!425 = !{!359, !359, !359, !359}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !427, file: !294, line: 1929)
!427 = !DISubprogram(name: "fmax", scope: !291, file: !291, line: 329, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !429, file: !294, line: 1930)
!429 = !DISubprogram(name: "fmaxf", scope: !291, file: !291, line: 329, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !431, file: !294, line: 1931)
!431 = !DISubprogram(name: "fmaxl", scope: !291, file: !291, line: 329, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !433, file: !294, line: 1933)
!433 = !DISubprogram(name: "fmin", scope: !291, file: !291, line: 332, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !435, file: !294, line: 1934)
!435 = !DISubprogram(name: "fminf", scope: !291, file: !291, line: 332, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !437, file: !294, line: 1935)
!437 = !DISubprogram(name: "fminl", scope: !291, file: !291, line: 332, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !439, file: !294, line: 1937)
!439 = !DISubprogram(name: "hypot", scope: !291, file: !291, line: 147, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !441, file: !294, line: 1938)
!441 = !DISubprogram(name: "hypotf", scope: !291, file: !291, line: 147, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !443, file: !294, line: 1939)
!443 = !DISubprogram(name: "hypotl", scope: !291, file: !291, line: 147, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !445, file: !294, line: 1941)
!445 = !DISubprogram(name: "ilogb", scope: !291, file: !291, line: 280, type: !446, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DISubroutineType(types: !447)
!447 = !{!98, !239}
!448 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !449, file: !294, line: 1942)
!449 = !DISubprogram(name: "ilogbf", scope: !291, file: !291, line: 280, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !451, file: !294, line: 1943)
!451 = !DISubprogram(name: "ilogbl", scope: !291, file: !291, line: 280, type: !452, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DISubroutineType(types: !453)
!453 = !{!98, !359}
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !455, file: !294, line: 1945)
!455 = !DISubprogram(name: "lgamma", scope: !291, file: !291, line: 230, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !457, file: !294, line: 1946)
!457 = !DISubprogram(name: "lgammaf", scope: !291, file: !291, line: 230, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !459, file: !294, line: 1947)
!459 = !DISubprogram(name: "lgammal", scope: !291, file: !291, line: 230, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !461, file: !294, line: 1950)
!461 = !DISubprogram(name: "llrint", scope: !291, file: !291, line: 316, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!462 = !DISubroutineType(types: !463)
!463 = !{!207, !239}
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !465, file: !294, line: 1951)
!465 = !DISubprogram(name: "llrintf", scope: !291, file: !291, line: 316, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !467, file: !294, line: 1952)
!467 = !DISubprogram(name: "llrintl", scope: !291, file: !291, line: 316, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DISubroutineType(types: !469)
!469 = !{!207, !359}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !471, file: !294, line: 1954)
!471 = !DISubprogram(name: "llround", scope: !291, file: !291, line: 322, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !473, file: !294, line: 1955)
!473 = !DISubprogram(name: "llroundf", scope: !291, file: !291, line: 322, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !475, file: !294, line: 1956)
!475 = !DISubprogram(name: "llroundl", scope: !291, file: !291, line: 322, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !477, file: !294, line: 1959)
!477 = !DISubprogram(name: "log1p", scope: !291, file: !291, line: 122, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !479, file: !294, line: 1960)
!479 = !DISubprogram(name: "log1pf", scope: !291, file: !291, line: 122, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !481, file: !294, line: 1961)
!481 = !DISubprogram(name: "log1pl", scope: !291, file: !291, line: 122, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !483, file: !294, line: 1963)
!483 = !DISubprogram(name: "log2", scope: !291, file: !291, line: 133, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !485, file: !294, line: 1964)
!485 = !DISubprogram(name: "log2f", scope: !291, file: !291, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !487, file: !294, line: 1965)
!487 = !DISubprogram(name: "log2l", scope: !291, file: !291, line: 133, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !489, file: !294, line: 1967)
!489 = !DISubprogram(name: "logb", scope: !291, file: !291, line: 125, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !491, file: !294, line: 1968)
!491 = !DISubprogram(name: "logbf", scope: !291, file: !291, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !493, file: !294, line: 1969)
!493 = !DISubprogram(name: "logbl", scope: !291, file: !291, line: 125, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !495, file: !294, line: 1971)
!495 = !DISubprogram(name: "lrint", scope: !291, file: !291, line: 314, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DISubroutineType(types: !497)
!497 = !{!196, !239}
!498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !499, file: !294, line: 1972)
!499 = !DISubprogram(name: "lrintf", scope: !291, file: !291, line: 314, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !501, file: !294, line: 1973)
!501 = !DISubprogram(name: "lrintl", scope: !291, file: !291, line: 314, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DISubroutineType(types: !503)
!503 = !{!196, !359}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !505, file: !294, line: 1975)
!505 = !DISubprogram(name: "lround", scope: !291, file: !291, line: 320, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !507, file: !294, line: 1976)
!507 = !DISubprogram(name: "lroundf", scope: !291, file: !291, line: 320, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !509, file: !294, line: 1977)
!509 = !DISubprogram(name: "lroundl", scope: !291, file: !291, line: 320, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !511, file: !294, line: 1979)
!511 = !DISubprogram(name: "nan", scope: !291, file: !291, line: 201, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!512 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !513, file: !294, line: 1980)
!513 = !DISubprogram(name: "nanf", scope: !291, file: !291, line: 201, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !515, file: !294, line: 1981)
!515 = !DISubprogram(name: "nanl", scope: !291, file: !291, line: 201, type: !516, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DISubroutineType(types: !517)
!517 = !{!359, !240}
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !519, file: !294, line: 1983)
!519 = !DISubprogram(name: "nearbyint", scope: !291, file: !291, line: 294, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !521, file: !294, line: 1984)
!521 = !DISubprogram(name: "nearbyintf", scope: !291, file: !291, line: 294, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !523, file: !294, line: 1985)
!523 = !DISubprogram(name: "nearbyintl", scope: !291, file: !291, line: 294, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !525, file: !294, line: 1987)
!525 = !DISubprogram(name: "nextafter", scope: !291, file: !291, line: 259, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !527, file: !294, line: 1988)
!527 = !DISubprogram(name: "nextafterf", scope: !291, file: !291, line: 259, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!528 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !529, file: !294, line: 1989)
!529 = !DISubprogram(name: "nextafterl", scope: !291, file: !291, line: 259, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !531, file: !294, line: 1991)
!531 = !DISubprogram(name: "nexttoward", scope: !291, file: !291, line: 261, type: !532, flags: DIFlagPrototyped, spFlags: 0)
!532 = !DISubroutineType(types: !533)
!533 = !{!239, !239, !359}
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !535, file: !294, line: 1992)
!535 = !DISubprogram(name: "nexttowardf", scope: !291, file: !291, line: 261, type: !536, flags: DIFlagPrototyped, spFlags: 0)
!536 = !DISubroutineType(types: !537)
!537 = !{!103, !103, !359}
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !539, file: !294, line: 1993)
!539 = !DISubprogram(name: "nexttowardl", scope: !291, file: !291, line: 261, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !541, file: !294, line: 1995)
!541 = !DISubprogram(name: "remainder", scope: !291, file: !291, line: 272, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !543, file: !294, line: 1996)
!543 = !DISubprogram(name: "remainderf", scope: !291, file: !291, line: 272, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !545, file: !294, line: 1997)
!545 = !DISubprogram(name: "remainderl", scope: !291, file: !291, line: 272, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !547, file: !294, line: 1999)
!547 = !DISubprogram(name: "remquo", scope: !291, file: !291, line: 307, type: !548, flags: DIFlagPrototyped, spFlags: 0)
!548 = !DISubroutineType(types: !549)
!549 = !{!239, !239, !239, !162}
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !551, file: !294, line: 2000)
!551 = !DISubprogram(name: "remquof", scope: !291, file: !291, line: 307, type: !257, flags: DIFlagPrototyped, spFlags: 0)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !553, file: !294, line: 2001)
!553 = !DISubprogram(name: "remquol", scope: !291, file: !291, line: 307, type: !554, flags: DIFlagPrototyped, spFlags: 0)
!554 = !DISubroutineType(types: !555)
!555 = !{!359, !359, !359, !162}
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !557, file: !294, line: 2003)
!557 = !DISubprogram(name: "rint", scope: !291, file: !291, line: 256, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !559, file: !294, line: 2004)
!559 = !DISubprogram(name: "rintf", scope: !291, file: !291, line: 256, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !561, file: !294, line: 2005)
!561 = !DISubprogram(name: "rintl", scope: !291, file: !291, line: 256, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !563, file: !294, line: 2007)
!563 = !DISubprogram(name: "round", scope: !291, file: !291, line: 298, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !565, file: !294, line: 2008)
!565 = !DISubprogram(name: "roundf", scope: !291, file: !291, line: 298, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !567, file: !294, line: 2009)
!567 = !DISubprogram(name: "roundl", scope: !291, file: !291, line: 298, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !569, file: !294, line: 2011)
!569 = !DISubprogram(name: "scalbln", scope: !291, file: !291, line: 290, type: !570, flags: DIFlagPrototyped, spFlags: 0)
!570 = !DISubroutineType(types: !571)
!571 = !{!239, !239, !196}
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !573, file: !294, line: 2012)
!573 = !DISubprogram(name: "scalblnf", scope: !291, file: !291, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !575, file: !294, line: 2013)
!575 = !DISubprogram(name: "scalblnl", scope: !291, file: !291, line: 290, type: !576, flags: DIFlagPrototyped, spFlags: 0)
!576 = !DISubroutineType(types: !577)
!577 = !{!359, !359, !196}
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !579, file: !294, line: 2015)
!579 = !DISubprogram(name: "scalbn", scope: !291, file: !291, line: 276, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !581, file: !294, line: 2016)
!581 = !DISubprogram(name: "scalbnf", scope: !291, file: !291, line: 276, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !583, file: !294, line: 2017)
!583 = !DISubprogram(name: "scalbnl", scope: !291, file: !291, line: 276, type: !584, flags: DIFlagPrototyped, spFlags: 0)
!584 = !DISubroutineType(types: !585)
!585 = !{!359, !359, !98}
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !587, file: !294, line: 2019)
!587 = !DISubprogram(name: "tgamma", scope: !291, file: !291, line: 235, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !589, file: !294, line: 2020)
!589 = !DISubprogram(name: "tgammaf", scope: !291, file: !291, line: 235, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !591, file: !294, line: 2021)
!591 = !DISubprogram(name: "tgammal", scope: !291, file: !291, line: 235, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !593, file: !294, line: 2023)
!593 = !DISubprogram(name: "trunc", scope: !291, file: !291, line: 302, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !595, file: !294, line: 2024)
!595 = !DISubprogram(name: "truncf", scope: !291, file: !291, line: 302, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !597, file: !294, line: 2025)
!597 = !DISubprogram(name: "truncl", scope: !291, file: !291, line: 302, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!598 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !599, entity: !600, file: !601, line: 58)
!599 = !DINamespace(name: "__gnu_debug", scope: null)
!600 = !DINamespace(name: "__debug", scope: !93)
!601 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/debug/debug.h", directory: "")
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !603, file: !605, line: 131)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !287, line: 62, baseType: !604)
!604 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 58, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!605 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cstdlib", directory: "")
!606 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !607, file: !605, line: 132)
!607 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !287, line: 70, baseType: !608)
!608 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !609, identifier: "_ZTS6ldiv_t")
!609 = !{!610, !611}
!610 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !608, file: !287, line: 68, baseType: !196, size: 64)
!611 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !608, file: !287, line: 69, baseType: !196, size: 64, offset: 64)
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !613, file: !605, line: 134)
!613 = !DISubprogram(name: "abort", scope: !287, file: !287, line: 588, type: !614, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!614 = !DISubroutineType(types: !615)
!615 = !{null}
!616 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !617, file: !605, line: 136)
!617 = !DISubprogram(name: "aligned_alloc", scope: !287, file: !287, line: 583, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!618 = !DISubroutineType(types: !619)
!619 = !{!620, !621, !621}
!620 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!621 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !622, line: 18, baseType: !623)
!622 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "")
!623 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!624 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !625, file: !605, line: 138)
!625 = !DISubprogram(name: "atexit", scope: !287, file: !287, line: 592, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!626 = !DISubroutineType(types: !627)
!627 = !{!98, !628}
!628 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !614, size: 64)
!629 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !630, file: !605, line: 141)
!630 = !DISubprogram(name: "at_quick_exit", scope: !287, file: !287, line: 597, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !632, file: !605, line: 144)
!632 = !DISubprogram(name: "atof", scope: !287, file: !287, line: 101, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !634, file: !605, line: 145)
!634 = !DISubprogram(name: "atoi", scope: !287, file: !287, line: 104, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!635 = !DISubroutineType(types: !636)
!636 = !{!98, !240}
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !638, file: !605, line: 146)
!638 = !DISubprogram(name: "atol", scope: !287, file: !287, line: 107, type: !639, flags: DIFlagPrototyped, spFlags: 0)
!639 = !DISubroutineType(types: !640)
!640 = !{!196, !240}
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !642, file: !605, line: 147)
!642 = !DISubprogram(name: "bsearch", scope: !287, file: !287, line: 817, type: !643, flags: DIFlagPrototyped, spFlags: 0)
!643 = !DISubroutineType(types: !644)
!644 = !{!620, !645, !645, !621, !621, !647}
!645 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !646, size: 64)
!646 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!647 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !287, line: 805, baseType: !648)
!648 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !649, size: 64)
!649 = !DISubroutineType(types: !650)
!650 = !{!98, !645, !645}
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !652, file: !605, line: 148)
!652 = !DISubprogram(name: "calloc", scope: !287, file: !287, line: 541, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !654, file: !605, line: 149)
!654 = !DISubprogram(name: "div", scope: !287, file: !287, line: 849, type: !655, flags: DIFlagPrototyped, spFlags: 0)
!655 = !DISubroutineType(types: !656)
!656 = !{!603, !98, !98}
!657 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !658, file: !605, line: 150)
!658 = !DISubprogram(name: "exit", scope: !287, file: !287, line: 614, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!659 = !DISubroutineType(types: !660)
!660 = !{null, !98}
!661 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !662, file: !605, line: 151)
!662 = !DISubprogram(name: "free", scope: !287, file: !287, line: 563, type: !663, flags: DIFlagPrototyped, spFlags: 0)
!663 = !DISubroutineType(types: !664)
!664 = !{null, !620}
!665 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !666, file: !605, line: 152)
!666 = !DISubprogram(name: "getenv", scope: !287, file: !287, line: 631, type: !667, flags: DIFlagPrototyped, spFlags: 0)
!667 = !DISubroutineType(types: !668)
!668 = !{!669, !240}
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !671, file: !605, line: 153)
!671 = !DISubprogram(name: "labs", scope: !287, file: !287, line: 838, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !673, file: !605, line: 154)
!673 = !DISubprogram(name: "ldiv", scope: !287, file: !287, line: 851, type: !674, flags: DIFlagPrototyped, spFlags: 0)
!674 = !DISubroutineType(types: !675)
!675 = !{!607, !196, !196}
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !677, file: !605, line: 155)
!677 = !DISubprogram(name: "malloc", scope: !287, file: !287, line: 539, type: !678, flags: DIFlagPrototyped, spFlags: 0)
!678 = !DISubroutineType(types: !679)
!679 = !{!620, !621}
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !681, file: !605, line: 157)
!681 = !DISubprogram(name: "mblen", scope: !287, file: !287, line: 919, type: !682, flags: DIFlagPrototyped, spFlags: 0)
!682 = !DISubroutineType(types: !683)
!683 = !{!98, !240, !621}
!684 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !685, file: !605, line: 158)
!685 = !DISubprogram(name: "mbstowcs", scope: !287, file: !287, line: 930, type: !686, flags: DIFlagPrototyped, spFlags: 0)
!686 = !DISubroutineType(types: !687)
!687 = !{!621, !688, !691, !621}
!688 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !689)
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!691 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !240)
!692 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !693, file: !605, line: 159)
!693 = !DISubprogram(name: "mbtowc", scope: !287, file: !287, line: 922, type: !694, flags: DIFlagPrototyped, spFlags: 0)
!694 = !DISubroutineType(types: !695)
!695 = !{!98, !688, !691, !621}
!696 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !697, file: !605, line: 161)
!697 = !DISubprogram(name: "qsort", scope: !287, file: !287, line: 827, type: !698, flags: DIFlagPrototyped, spFlags: 0)
!698 = !DISubroutineType(types: !699)
!699 = !{null, !620, !621, !621, !647}
!700 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !701, file: !605, line: 164)
!701 = !DISubprogram(name: "quick_exit", scope: !287, file: !287, line: 620, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !703, file: !605, line: 167)
!703 = !DISubprogram(name: "rand", scope: !287, file: !287, line: 453, type: !704, flags: DIFlagPrototyped, spFlags: 0)
!704 = !DISubroutineType(types: !705)
!705 = !{!98}
!706 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !707, file: !605, line: 168)
!707 = !DISubprogram(name: "realloc", scope: !287, file: !287, line: 549, type: !708, flags: DIFlagPrototyped, spFlags: 0)
!708 = !DISubroutineType(types: !709)
!709 = !{!620, !620, !621}
!710 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !711, file: !605, line: 169)
!711 = !DISubprogram(name: "srand", scope: !287, file: !287, line: 455, type: !712, flags: DIFlagPrototyped, spFlags: 0)
!712 = !DISubroutineType(types: !713)
!713 = !{null, !39}
!714 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !715, file: !605, line: 170)
!715 = !DISubprogram(name: "strtod", scope: !287, file: !287, line: 117, type: !716, flags: DIFlagPrototyped, spFlags: 0)
!716 = !DISubroutineType(types: !717)
!717 = !{!239, !691, !718}
!718 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !719)
!719 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !669, size: 64)
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !721, file: !605, line: 171)
!721 = !DISubprogram(name: "strtol", scope: !287, file: !287, line: 176, type: !722, flags: DIFlagPrototyped, spFlags: 0)
!722 = !DISubroutineType(types: !723)
!723 = !{!196, !691, !718, !98}
!724 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !725, file: !605, line: 172)
!725 = !DISubprogram(name: "strtoul", scope: !287, file: !287, line: 180, type: !726, flags: DIFlagPrototyped, spFlags: 0)
!726 = !DISubroutineType(types: !727)
!727 = !{!623, !691, !718, !98}
!728 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !729, file: !605, line: 173)
!729 = !DISubprogram(name: "system", scope: !287, file: !287, line: 781, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !731, file: !605, line: 175)
!731 = !DISubprogram(name: "wcstombs", scope: !287, file: !287, line: 933, type: !732, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DISubroutineType(types: !733)
!733 = !{!621, !734, !735, !621}
!734 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !669)
!735 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !736)
!736 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !737, size: 64)
!737 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !690)
!738 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !739, file: !605, line: 176)
!739 = !DISubprogram(name: "wctomb", scope: !287, file: !287, line: 926, type: !740, flags: DIFlagPrototyped, spFlags: 0)
!740 = !DISubroutineType(types: !741)
!741 = !{!98, !669, !690}
!742 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !744, file: !605, line: 204)
!743 = !DINamespace(name: "__gnu_cxx", scope: null)
!744 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !287, line: 80, baseType: !745)
!745 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !746, identifier: "_ZTS7lldiv_t")
!746 = !{!747, !748}
!747 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !745, file: !287, line: 78, baseType: !207, size: 64)
!748 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !745, file: !287, line: 79, baseType: !207, size: 64, offset: 64)
!749 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !750, file: !605, line: 210)
!750 = !DISubprogram(name: "_Exit", scope: !287, file: !287, line: 626, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !752, file: !605, line: 214)
!752 = !DISubprogram(name: "llabs", scope: !287, file: !287, line: 841, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!753 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !754, file: !605, line: 220)
!754 = !DISubprogram(name: "lldiv", scope: !287, file: !287, line: 855, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!755 = !DISubroutineType(types: !756)
!756 = !{!744, !207, !207}
!757 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !758, file: !605, line: 231)
!758 = !DISubprogram(name: "atoll", scope: !287, file: !287, line: 112, type: !759, flags: DIFlagPrototyped, spFlags: 0)
!759 = !DISubroutineType(types: !760)
!760 = !{!207, !240}
!761 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !762, file: !605, line: 232)
!762 = !DISubprogram(name: "strtoll", scope: !287, file: !287, line: 200, type: !763, flags: DIFlagPrototyped, spFlags: 0)
!763 = !DISubroutineType(types: !764)
!764 = !{!207, !691, !718, !98}
!765 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !766, file: !605, line: 233)
!766 = !DISubprogram(name: "strtoull", scope: !287, file: !287, line: 205, type: !767, flags: DIFlagPrototyped, spFlags: 0)
!767 = !DISubroutineType(types: !768)
!768 = !{!9, !691, !718, !98}
!769 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !770, file: !605, line: 235)
!770 = !DISubprogram(name: "strtof", scope: !287, file: !287, line: 123, type: !771, flags: DIFlagPrototyped, spFlags: 0)
!771 = !DISubroutineType(types: !772)
!772 = !{!103, !691, !718}
!773 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !774, file: !605, line: 236)
!774 = !DISubprogram(name: "strtold", scope: !287, file: !287, line: 126, type: !775, flags: DIFlagPrototyped, spFlags: 0)
!775 = !DISubroutineType(types: !776)
!776 = !{!359, !691, !718}
!777 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !744, file: !605, line: 244)
!778 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !750, file: !605, line: 246)
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !752, file: !605, line: 248)
!780 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !781, file: !605, line: 249)
!781 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !743, file: !605, line: 217, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!782 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !754, file: !605, line: 250)
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !758, file: !605, line: 252)
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !770, file: !605, line: 253)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !762, file: !605, line: 254)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !766, file: !605, line: 255)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !774, file: !605, line: 256)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !613, file: !789, line: 38)
!789 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/stdlib.h", directory: "")
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !625, file: !789, line: 39)
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !658, file: !789, line: 40)
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !630, file: !789, line: 43)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !701, file: !789, line: 46)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !750, file: !789, line: 49)
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !603, file: !789, line: 54)
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !607, file: !789, line: 55)
!797 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !789, line: 57)
!798 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !93, file: !288, line: 137, type: !799, flags: DIFlagPrototyped, spFlags: 0)
!799 = !DISubroutineType(types: !800)
!800 = !{!801, !801}
!801 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!802 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !632, file: !789, line: 58)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !634, file: !789, line: 59)
!804 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !638, file: !789, line: 60)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !642, file: !789, line: 61)
!806 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !652, file: !789, line: 62)
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !781, file: !789, line: 63)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !662, file: !789, line: 64)
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !666, file: !789, line: 65)
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !671, file: !789, line: 66)
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !673, file: !789, line: 67)
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !677, file: !789, line: 68)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !681, file: !789, line: 70)
!814 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !685, file: !789, line: 71)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !693, file: !789, line: 72)
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !697, file: !789, line: 74)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !703, file: !789, line: 75)
!818 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !707, file: !789, line: 76)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !711, file: !789, line: 77)
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !715, file: !789, line: 78)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !721, file: !789, line: 79)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !725, file: !789, line: 80)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !729, file: !789, line: 81)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !731, file: !789, line: 83)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !739, file: !789, line: 84)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !827, file: !829, line: 443)
!827 = !DISubprogram(name: "acosf", linkageName: "_ZL5acosff", scope: !828, file: !828, line: 63, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!828 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math.h", directory: "")
!829 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_cmath.h", directory: "")
!830 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !831, file: !829, line: 444)
!831 = !DISubprogram(name: "acoshf", linkageName: "_ZL6acoshff", scope: !828, file: !828, line: 65, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!832 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !833, file: !829, line: 445)
!833 = !DISubprogram(name: "asinf", linkageName: "_ZL5asinff", scope: !828, file: !828, line: 67, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!834 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !835, file: !829, line: 446)
!835 = !DISubprogram(name: "asinhf", linkageName: "_ZL6asinhff", scope: !828, file: !828, line: 69, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !837, file: !829, line: 447)
!837 = !DISubprogram(name: "atan2f", linkageName: "_ZL6atan2fff", scope: !828, file: !828, line: 72, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !839, file: !829, line: 448)
!839 = !DISubprogram(name: "atanf", linkageName: "_ZL5atanff", scope: !828, file: !828, line: 73, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !841, file: !829, line: 449)
!841 = !DISubprogram(name: "atanhf", linkageName: "_ZL6atanhff", scope: !828, file: !828, line: 75, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !843, file: !829, line: 450)
!843 = !DISubprogram(name: "cbrtf", linkageName: "_ZL5cbrtff", scope: !828, file: !828, line: 77, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !845, file: !829, line: 451)
!845 = !DISubprogram(name: "ceilf", linkageName: "_ZL5ceilff", scope: !828, file: !828, line: 79, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !847, file: !829, line: 452)
!847 = !DISubprogram(name: "copysignf", linkageName: "_ZL9copysignfff", scope: !828, file: !828, line: 83, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !849, file: !829, line: 453)
!849 = !DISubprogram(name: "cosf", linkageName: "_ZL4cosff", scope: !828, file: !828, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !851, file: !829, line: 454)
!851 = !DISubprogram(name: "coshf", linkageName: "_ZL5coshff", scope: !828, file: !828, line: 91, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !853, file: !829, line: 455)
!853 = !DISubprogram(name: "erfcf", linkageName: "_ZL5erfcff", scope: !828, file: !828, line: 100, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !855, file: !829, line: 456)
!855 = !DISubprogram(name: "erff", linkageName: "_ZL4erfff", scope: !828, file: !828, line: 105, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !857, file: !829, line: 457)
!857 = !DISubprogram(name: "exp2f", linkageName: "_ZL5exp2ff", scope: !828, file: !828, line: 112, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !859, file: !829, line: 458)
!859 = !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !828, file: !828, line: 113, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!860 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !861, file: !829, line: 459)
!861 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !828, file: !828, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!862 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !863, file: !829, line: 460)
!863 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !828, file: !828, line: 116, type: !101, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!864 = !{}
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !866, file: !829, line: 461)
!866 = !DISubprogram(name: "fdimf", linkageName: "_ZL5fdimfff", scope: !828, file: !828, line: 118, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !868, file: !829, line: 462)
!868 = !DISubprogram(name: "floorf", linkageName: "_ZL6floorff", scope: !828, file: !828, line: 128, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!869 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !870, file: !829, line: 463)
!870 = !DISubprogram(name: "fmaf", linkageName: "_ZL4fmaffff", scope: !828, file: !828, line: 132, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !872, file: !829, line: 464)
!872 = !DISubprogram(name: "fmaxf", linkageName: "_ZL5fmaxfff", scope: !828, file: !828, line: 136, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!873 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !874, file: !829, line: 465)
!874 = !DISubprogram(name: "fminf", linkageName: "_ZL5fminfff", scope: !828, file: !828, line: 138, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !876, file: !829, line: 466)
!876 = !DISubprogram(name: "fmodf", linkageName: "_ZL5fmodfff", scope: !828, file: !828, line: 140, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!877 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !878, file: !829, line: 467)
!878 = !DISubprogram(name: "frexpf", linkageName: "_ZL6frexpffPi", scope: !828, file: !828, line: 142, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!879 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !880, file: !829, line: 468)
!880 = !DISubprogram(name: "hypotf", linkageName: "_ZL6hypotfff", scope: !828, file: !828, line: 144, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!881 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !882, file: !829, line: 469)
!882 = !DISubprogram(name: "ilogbf", linkageName: "_ZL6ilogbff", scope: !828, file: !828, line: 146, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !884, file: !829, line: 470)
!884 = !DISubprogram(name: "ldexpf", linkageName: "_ZL6ldexpffi", scope: !828, file: !828, line: 159, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!885 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !886, file: !829, line: 471)
!886 = !DISubprogram(name: "lgammaf", linkageName: "_ZL7lgammaff", scope: !828, file: !828, line: 161, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !888, file: !829, line: 472)
!888 = !DISubprogram(name: "llrintf", linkageName: "_ZL7llrintff", scope: !828, file: !828, line: 170, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !890, file: !829, line: 473)
!890 = !DISubprogram(name: "llroundf", linkageName: "_ZL8llroundff", scope: !828, file: !828, line: 172, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !892, file: !829, line: 474)
!892 = !DISubprogram(name: "log10f", linkageName: "_ZL6log10ff", scope: !828, file: !828, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !894, file: !829, line: 475)
!894 = !DISubprogram(name: "log1pf", linkageName: "_ZL6log1pff", scope: !828, file: !828, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!895 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !896, file: !829, line: 476)
!896 = !DISubprogram(name: "log2f", linkageName: "_ZL5log2ff", scope: !828, file: !828, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !898, file: !829, line: 477)
!898 = !DISubprogram(name: "logbf", linkageName: "_ZL5logbff", scope: !828, file: !828, line: 185, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!899 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !900, file: !829, line: 478)
!900 = !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !828, file: !828, line: 186, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !902, file: !829, line: 479)
!902 = !DISubprogram(name: "lrintf", linkageName: "_ZL6lrintff", scope: !828, file: !828, line: 191, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !904, file: !829, line: 480)
!904 = !DISubprogram(name: "lroundf", linkageName: "_ZL7lroundff", scope: !828, file: !828, line: 193, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !906, file: !829, line: 481)
!906 = !DISubprogram(name: "modff", linkageName: "_ZL5modfffPf", scope: !828, file: !828, line: 203, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !908, file: !829, line: 482)
!908 = !DISubprogram(name: "nearbyintf", linkageName: "_ZL10nearbyintff", scope: !828, file: !828, line: 205, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !910, file: !829, line: 483)
!910 = !DISubprogram(name: "nextafterf", linkageName: "_ZL10nextafterfff", scope: !828, file: !828, line: 209, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !912, file: !829, line: 484)
!912 = !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !828, file: !828, line: 235, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !914, file: !829, line: 485)
!914 = !DISubprogram(name: "remainderf", linkageName: "_ZL10remainderfff", scope: !828, file: !828, line: 243, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !916, file: !829, line: 486)
!916 = !DISubprogram(name: "remquof", linkageName: "_ZL7remquofffPi", scope: !828, file: !828, line: 249, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !918, file: !829, line: 487)
!918 = !DISubprogram(name: "rintf", linkageName: "_ZL5rintff", scope: !828, file: !828, line: 260, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !920, file: !829, line: 488)
!920 = !DISubprogram(name: "roundf", linkageName: "_ZL6roundff", scope: !828, file: !828, line: 174, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !922, file: !829, line: 489)
!922 = !DISubprogram(name: "scalblnf", linkageName: "_ZL8scalblnffl", scope: !828, file: !828, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!923 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !924, file: !829, line: 490)
!924 = !DISubprogram(name: "scalbnf", linkageName: "_ZL7scalbnffi", scope: !828, file: !828, line: 282, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !926, file: !829, line: 491)
!926 = !DISubprogram(name: "sinf", linkageName: "_ZL4sinff", scope: !828, file: !828, line: 310, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !928, file: !829, line: 492)
!928 = !DISubprogram(name: "sinhf", linkageName: "_ZL5sinhff", scope: !828, file: !828, line: 314, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !930, file: !829, line: 493)
!930 = !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !828, file: !828, line: 318, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !932, file: !829, line: 494)
!932 = !DISubprogram(name: "tanf", linkageName: "_ZL4tanff", scope: !828, file: !828, line: 320, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !934, file: !829, line: 495)
!934 = !DISubprogram(name: "tanhf", linkageName: "_ZL5tanhff", scope: !828, file: !828, line: 322, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !936, file: !829, line: 496)
!936 = !DISubprogram(name: "tgammaf", linkageName: "_ZL7tgammaff", scope: !828, file: !828, line: 324, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !938, file: !829, line: 497)
!938 = !DISubprogram(name: "truncf", linkageName: "_ZL6truncff", scope: !828, file: !828, line: 326, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !3, file: !4, line: 181)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !28, file: !4, line: 182)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !942, file: !4, line: 208)
!942 = !DISubprogram(name: "is_exactly", linkageName: "_ZN2nv6target6detail10is_exactlyENS1_11sm_selectorE", scope: !5, file: !4, line: 153, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!943 = !DISubroutineType(types: !944)
!944 = !{!28, !3}
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !946, file: !4, line: 209)
!946 = !DISubprogram(name: "provides", linkageName: "_ZN2nv6target6detail8providesENS1_11sm_selectorE", scope: !5, file: !4, line: 158, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !948, line: 38)
!948 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/math.h", directory: "")
!949 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !950, file: !948, line: 54)
!950 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !93, file: !294, line: 364, type: !951, flags: DIFlagPrototyped, spFlags: 0)
!951 = !DISubroutineType(types: !952)
!952 = !{!359, !359, !953}
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !359, size: 64)
!954 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!955 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!956 = !{i32 2, i32 0}
!957 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!958 = !{i32 7, !"Dwarf Version", i32 2}
!959 = !{i32 2, !"Debug Info Version", i32 3}
!960 = !{i32 1, !"wchar_size", i32 4}
!961 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!962 = !{i32 7, !"frame-pointer", i32 2}
!963 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !1, file: !1, line: 7, type: !169, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!964 = !DILocalVariable(name: "x", arg: 1, scope: !963, file: !1, line: 7, type: !103)
!965 = !DILocation(line: 7, column: 36, scope: !963)
!966 = !DILocation(line: 8, column: 13, scope: !963)
!967 = !DILocation(line: 8, column: 15, scope: !963)
!968 = !DILocation(line: 8, column: 24, scope: !963)
!969 = !DILocation(line: 8, column: 34, scope: !963)
!970 = !DILocalVariable(name: "__a", arg: 1, scope: !863, file: !828, line: 116, type: !103)
!971 = !DILocation(line: 116, column: 30, scope: !863, inlinedAt: !972)
!972 = distinct !DILocation(line: 8, column: 28, scope: !963)
!973 = !DILocation(line: 116, column: 55, scope: !863, inlinedAt: !972)
!974 = !DILocation(line: 116, column: 44, scope: !863, inlinedAt: !972)
!975 = !DILocation(line: 8, column: 37, scope: !963)
!976 = !DILocation(line: 0, scope: !963)
!977 = !DILocation(line: 8, column: 5, scope: !963)
!978 = distinct !DISubprogram(name: "testUnderflow_RoundNearest", linkageName: "_Z26testUnderflow_RoundNearestPfPi", scope: !1, file: !1, line: 11, type: !979, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!979 = !DISubroutineType(types: !980)
!980 = !{null, !234, !162}
!981 = !DILocalVariable(name: "result", arg: 1, scope: !978, file: !1, line: 11, type: !234)
!982 = !DILocation(line: 11, column: 51, scope: !978)
!983 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !978, file: !1, line: 11, type: !162)
!984 = !DILocation(line: 11, column: 64, scope: !978)
!985 = !DILocalVariable(name: "idx", scope: !978, file: !1, line: 12, type: !98)
!986 = !DILocation(line: 12, column: 9, scope: !978)
!987 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!989 = distinct !DILocation(line: 12, column: 15, scope: !978)
!990 = !DILocalVariable(name: "tiny", scope: !978, file: !1, line: 14, type: !103)
!991 = !DILocation(line: 14, column: 11, scope: !978)
!992 = !DILocation(line: 18, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !978, file: !1, line: 18, column: 9)
!994 = !DILocation(line: 18, column: 13, scope: !993)
!995 = !DILocation(line: 20, column: 31, scope: !996)
!996 = distinct !DILexicalBlock(scope: !993, file: !1, line: 18, column: 19)
!997 = !DILocalVariable(name: "__a", arg: 1, scope: !998, file: !999, line: 212, type: !103)
!998 = distinct !DISubprogram(name: "__fdiv_rn", linkageName: "_ZL9__fdiv_rnff", scope: !999, file: !999, line: 212, type: !114, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!999 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_device_functions.h", directory: "")
!1000 = !DILocation(line: 212, column: 34, scope: !998, inlinedAt: !1001)
!1001 = distinct !DILocation(line: 20, column: 21, scope: !996)
!1002 = !DILocalVariable(name: "__b", arg: 2, scope: !998, file: !999, line: 212, type: !103)
!1003 = !DILocation(line: 212, column: 45, scope: !998, inlinedAt: !1001)
!1004 = !DILocation(line: 213, column: 23, scope: !998, inlinedAt: !1001)
!1005 = !DILocation(line: 213, column: 28, scope: !998, inlinedAt: !1001)
!1006 = !DILocation(line: 213, column: 10, scope: !998, inlinedAt: !1001)
!1007 = !DILocation(line: 20, column: 9, scope: !996)
!1008 = !DILocation(line: 20, column: 19, scope: !996)
!1009 = !DILocation(line: 21, column: 39, scope: !996)
!1010 = !DILocation(line: 21, column: 26, scope: !996)
!1011 = !DILocation(line: 21, column: 9, scope: !996)
!1012 = !DILocation(line: 21, column: 24, scope: !996)
!1013 = !DILocation(line: 22, column: 5, scope: !996)
!1014 = !DILocation(line: 24, column: 9, scope: !1015)
!1015 = distinct !DILexicalBlock(scope: !978, file: !1, line: 24, column: 9)
!1016 = !DILocation(line: 24, column: 13, scope: !1015)
!1017 = !DILocation(line: 26, column: 31, scope: !1018)
!1018 = distinct !DILexicalBlock(scope: !1015, file: !1, line: 24, column: 19)
!1019 = !DILocalVariable(name: "__a", arg: 1, scope: !1020, file: !999, line: 306, type: !103)
!1020 = distinct !DISubprogram(name: "__fmul_rn", linkageName: "_ZL9__fmul_rnff", scope: !999, file: !999, line: 306, type: !114, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1021 = !DILocation(line: 306, column: 34, scope: !1020, inlinedAt: !1022)
!1022 = distinct !DILocation(line: 26, column: 21, scope: !1018)
!1023 = !DILocalVariable(name: "__b", arg: 2, scope: !1020, file: !999, line: 306, type: !103)
!1024 = !DILocation(line: 306, column: 45, scope: !1020, inlinedAt: !1022)
!1025 = !DILocation(line: 307, column: 23, scope: !1020, inlinedAt: !1022)
!1026 = !DILocation(line: 307, column: 28, scope: !1020, inlinedAt: !1022)
!1027 = !DILocation(line: 307, column: 10, scope: !1020, inlinedAt: !1022)
!1028 = !DILocation(line: 26, column: 9, scope: !1018)
!1029 = !DILocation(line: 26, column: 19, scope: !1018)
!1030 = !DILocation(line: 27, column: 39, scope: !1018)
!1031 = !DILocation(line: 27, column: 26, scope: !1018)
!1032 = !DILocation(line: 27, column: 9, scope: !1018)
!1033 = !DILocation(line: 27, column: 24, scope: !1018)
!1034 = !DILocation(line: 28, column: 5, scope: !1018)
!1035 = !DILocation(line: 30, column: 9, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !978, file: !1, line: 30, column: 9)
!1037 = !DILocation(line: 30, column: 13, scope: !1036)
!1038 = !DILocation(line: 32, column: 31, scope: !1039)
!1039 = distinct !DILexicalBlock(scope: !1036, file: !1, line: 30, column: 19)
!1040 = !DILocation(line: 306, column: 34, scope: !1020, inlinedAt: !1041)
!1041 = distinct !DILocation(line: 32, column: 21, scope: !1039)
!1042 = !DILocation(line: 306, column: 45, scope: !1020, inlinedAt: !1041)
!1043 = !DILocation(line: 307, column: 23, scope: !1020, inlinedAt: !1041)
!1044 = !DILocation(line: 307, column: 28, scope: !1020, inlinedAt: !1041)
!1045 = !DILocation(line: 307, column: 10, scope: !1020, inlinedAt: !1041)
!1046 = !DILocation(line: 32, column: 9, scope: !1039)
!1047 = !DILocation(line: 32, column: 19, scope: !1039)
!1048 = !DILocation(line: 33, column: 39, scope: !1039)
!1049 = !DILocation(line: 33, column: 26, scope: !1039)
!1050 = !DILocation(line: 33, column: 9, scope: !1039)
!1051 = !DILocation(line: 33, column: 24, scope: !1039)
!1052 = !DILocation(line: 34, column: 5, scope: !1039)
!1053 = !DILocation(line: 36, column: 9, scope: !1054)
!1054 = distinct !DILexicalBlock(scope: !978, file: !1, line: 36, column: 9)
!1055 = !DILocation(line: 36, column: 13, scope: !1054)
!1056 = !DILocalVariable(name: "a", scope: !1057, file: !1, line: 38, type: !103)
!1057 = distinct !DILexicalBlock(scope: !1054, file: !1, line: 36, column: 19)
!1058 = !DILocation(line: 38, column: 15, scope: !1057)
!1059 = !DILocation(line: 38, column: 19, scope: !1057)
!1060 = !DILocation(line: 38, column: 24, scope: !1057)
!1061 = !DILocalVariable(name: "b", scope: !1057, file: !1, line: 39, type: !103)
!1062 = !DILocation(line: 39, column: 15, scope: !1057)
!1063 = !DILocation(line: 39, column: 19, scope: !1057)
!1064 = !DILocation(line: 40, column: 31, scope: !1057)
!1065 = !DILocation(line: 40, column: 34, scope: !1057)
!1066 = !DILocalVariable(name: "__a", arg: 1, scope: !1067, file: !999, line: 327, type: !103)
!1067 = distinct !DISubprogram(name: "__fsub_rn", linkageName: "_ZL9__fsub_rnff", scope: !999, file: !999, line: 327, type: !114, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1068 = !DILocation(line: 327, column: 34, scope: !1067, inlinedAt: !1069)
!1069 = distinct !DILocation(line: 40, column: 21, scope: !1057)
!1070 = !DILocalVariable(name: "__b", arg: 2, scope: !1067, file: !999, line: 327, type: !103)
!1071 = !DILocation(line: 327, column: 45, scope: !1067, inlinedAt: !1069)
!1072 = !DILocation(line: 328, column: 23, scope: !1067, inlinedAt: !1069)
!1073 = !DILocation(line: 328, column: 28, scope: !1067, inlinedAt: !1069)
!1074 = !DILocation(line: 328, column: 10, scope: !1067, inlinedAt: !1069)
!1075 = !{i32 9580}
!1076 = !DILocation(line: 40, column: 9, scope: !1057)
!1077 = !DILocation(line: 40, column: 19, scope: !1057)
!1078 = !DILocation(line: 41, column: 39, scope: !1057)
!1079 = !DILocation(line: 41, column: 26, scope: !1057)
!1080 = !DILocation(line: 41, column: 9, scope: !1057)
!1081 = !DILocation(line: 41, column: 24, scope: !1057)
!1082 = !DILocation(line: 42, column: 5, scope: !1057)
!1083 = !DILocation(line: 44, column: 9, scope: !1084)
!1084 = distinct !DILexicalBlock(scope: !978, file: !1, line: 44, column: 9)
!1085 = !DILocation(line: 44, column: 13, scope: !1084)
!1086 = !DILocation(line: 46, column: 31, scope: !1087)
!1087 = distinct !DILexicalBlock(scope: !1084, file: !1, line: 44, column: 19)
!1088 = !DILocalVariable(name: "__a", arg: 1, scope: !1089, file: !999, line: 294, type: !103)
!1089 = distinct !DISubprogram(name: "__fmaf_rn", linkageName: "_ZL9__fmaf_rnfff", scope: !999, file: !999, line: 294, type: !146, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1090 = !DILocation(line: 294, column: 34, scope: !1089, inlinedAt: !1091)
!1091 = distinct !DILocation(line: 46, column: 21, scope: !1087)
!1092 = !DILocalVariable(name: "__b", arg: 2, scope: !1089, file: !999, line: 294, type: !103)
!1093 = !DILocation(line: 294, column: 45, scope: !1089, inlinedAt: !1091)
!1094 = !DILocalVariable(name: "__c", arg: 3, scope: !1089, file: !999, line: 294, type: !103)
!1095 = !DILocation(line: 294, column: 56, scope: !1089, inlinedAt: !1091)
!1096 = !DILocation(line: 295, column: 23, scope: !1089, inlinedAt: !1091)
!1097 = !DILocation(line: 295, column: 28, scope: !1089, inlinedAt: !1091)
!1098 = !DILocation(line: 295, column: 33, scope: !1089, inlinedAt: !1091)
!1099 = !DILocation(line: 295, column: 10, scope: !1089, inlinedAt: !1091)
!1100 = !DILocation(line: 46, column: 9, scope: !1087)
!1101 = !DILocation(line: 46, column: 19, scope: !1087)
!1102 = !DILocation(line: 47, column: 39, scope: !1087)
!1103 = !DILocation(line: 47, column: 26, scope: !1087)
!1104 = !DILocation(line: 47, column: 9, scope: !1087)
!1105 = !DILocation(line: 47, column: 24, scope: !1087)
!1106 = !DILocation(line: 48, column: 5, scope: !1087)
!1107 = !DILocation(line: 49, column: 1, scope: !978)
!1108 = distinct !DISubprogram(name: "testUnderflow_RoundZero", linkageName: "_Z23testUnderflow_RoundZeroPfPi", scope: !1, file: !1, line: 51, type: !979, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1109 = !DILocalVariable(name: "result", arg: 1, scope: !1108, file: !1, line: 51, type: !234)
!1110 = !DILocation(line: 51, column: 48, scope: !1108)
!1111 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1108, file: !1, line: 51, type: !162)
!1112 = !DILocation(line: 51, column: 61, scope: !1108)
!1113 = !DILocalVariable(name: "idx", scope: !1108, file: !1, line: 52, type: !98)
!1114 = !DILocation(line: 52, column: 9, scope: !1108)
!1115 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1116)
!1116 = distinct !DILocation(line: 52, column: 15, scope: !1108)
!1117 = !DILocalVariable(name: "tiny", scope: !1108, file: !1, line: 54, type: !103)
!1118 = !DILocation(line: 54, column: 11, scope: !1108)
!1119 = !DILocation(line: 58, column: 9, scope: !1120)
!1120 = distinct !DILexicalBlock(scope: !1108, file: !1, line: 58, column: 9)
!1121 = !DILocation(line: 58, column: 13, scope: !1120)
!1122 = !DILocation(line: 59, column: 31, scope: !1123)
!1123 = distinct !DILexicalBlock(scope: !1120, file: !1, line: 58, column: 19)
!1124 = !DILocalVariable(name: "__a", arg: 1, scope: !1125, file: !999, line: 218, type: !103)
!1125 = distinct !DISubprogram(name: "__fdiv_rz", linkageName: "_ZL9__fdiv_rzff", scope: !999, file: !999, line: 218, type: !114, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1126 = !DILocation(line: 218, column: 34, scope: !1125, inlinedAt: !1127)
!1127 = distinct !DILocation(line: 59, column: 21, scope: !1123)
!1128 = !DILocalVariable(name: "__b", arg: 2, scope: !1125, file: !999, line: 218, type: !103)
!1129 = !DILocation(line: 218, column: 45, scope: !1125, inlinedAt: !1127)
!1130 = !DILocation(line: 219, column: 23, scope: !1125, inlinedAt: !1127)
!1131 = !DILocation(line: 219, column: 28, scope: !1125, inlinedAt: !1127)
!1132 = !DILocation(line: 219, column: 10, scope: !1125, inlinedAt: !1127)
!1133 = !DILocation(line: 59, column: 9, scope: !1123)
!1134 = !DILocation(line: 59, column: 19, scope: !1123)
!1135 = !DILocation(line: 60, column: 39, scope: !1123)
!1136 = !DILocation(line: 60, column: 26, scope: !1123)
!1137 = !DILocation(line: 60, column: 9, scope: !1123)
!1138 = !DILocation(line: 60, column: 24, scope: !1123)
!1139 = !DILocation(line: 61, column: 5, scope: !1123)
!1140 = !DILocation(line: 63, column: 9, scope: !1141)
!1141 = distinct !DILexicalBlock(scope: !1108, file: !1, line: 63, column: 9)
!1142 = !DILocation(line: 63, column: 13, scope: !1141)
!1143 = !DILocation(line: 64, column: 31, scope: !1144)
!1144 = distinct !DILexicalBlock(scope: !1141, file: !1, line: 63, column: 19)
!1145 = !DILocalVariable(name: "__a", arg: 1, scope: !1146, file: !999, line: 312, type: !103)
!1146 = distinct !DISubprogram(name: "__fmul_rz", linkageName: "_ZL9__fmul_rzff", scope: !999, file: !999, line: 312, type: !114, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1147 = !DILocation(line: 312, column: 34, scope: !1146, inlinedAt: !1148)
!1148 = distinct !DILocation(line: 64, column: 21, scope: !1144)
!1149 = !DILocalVariable(name: "__b", arg: 2, scope: !1146, file: !999, line: 312, type: !103)
!1150 = !DILocation(line: 312, column: 45, scope: !1146, inlinedAt: !1148)
!1151 = !DILocation(line: 313, column: 23, scope: !1146, inlinedAt: !1148)
!1152 = !DILocation(line: 313, column: 28, scope: !1146, inlinedAt: !1148)
!1153 = !DILocation(line: 313, column: 10, scope: !1146, inlinedAt: !1148)
!1154 = !DILocation(line: 64, column: 9, scope: !1144)
!1155 = !DILocation(line: 64, column: 19, scope: !1144)
!1156 = !DILocation(line: 65, column: 39, scope: !1144)
!1157 = !DILocation(line: 65, column: 26, scope: !1144)
!1158 = !DILocation(line: 65, column: 9, scope: !1144)
!1159 = !DILocation(line: 65, column: 24, scope: !1144)
!1160 = !DILocation(line: 66, column: 5, scope: !1144)
!1161 = !DILocation(line: 68, column: 9, scope: !1162)
!1162 = distinct !DILexicalBlock(scope: !1108, file: !1, line: 68, column: 9)
!1163 = !DILocation(line: 68, column: 13, scope: !1162)
!1164 = !DILocation(line: 70, column: 31, scope: !1165)
!1165 = distinct !DILexicalBlock(scope: !1162, file: !1, line: 68, column: 19)
!1166 = !DILocation(line: 312, column: 34, scope: !1146, inlinedAt: !1167)
!1167 = distinct !DILocation(line: 70, column: 21, scope: !1165)
!1168 = !DILocation(line: 312, column: 45, scope: !1146, inlinedAt: !1167)
!1169 = !DILocation(line: 313, column: 23, scope: !1146, inlinedAt: !1167)
!1170 = !DILocation(line: 313, column: 28, scope: !1146, inlinedAt: !1167)
!1171 = !DILocation(line: 313, column: 10, scope: !1146, inlinedAt: !1167)
!1172 = !DILocation(line: 70, column: 9, scope: !1165)
!1173 = !DILocation(line: 70, column: 19, scope: !1165)
!1174 = !DILocation(line: 71, column: 39, scope: !1165)
!1175 = !DILocation(line: 71, column: 26, scope: !1165)
!1176 = !DILocation(line: 71, column: 9, scope: !1165)
!1177 = !DILocation(line: 71, column: 24, scope: !1165)
!1178 = !DILocation(line: 72, column: 5, scope: !1165)
!1179 = !DILocation(line: 73, column: 1, scope: !1108)
!1180 = distinct !DISubprogram(name: "testUnderflow_RoundUp", linkageName: "_Z21testUnderflow_RoundUpPfPi", scope: !1, file: !1, line: 75, type: !979, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1181 = !DILocalVariable(name: "result", arg: 1, scope: !1180, file: !1, line: 75, type: !234)
!1182 = !DILocation(line: 75, column: 46, scope: !1180)
!1183 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1180, file: !1, line: 75, type: !162)
!1184 = !DILocation(line: 75, column: 59, scope: !1180)
!1185 = !DILocalVariable(name: "idx", scope: !1180, file: !1, line: 76, type: !98)
!1186 = !DILocation(line: 76, column: 9, scope: !1180)
!1187 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1188)
!1188 = distinct !DILocation(line: 76, column: 15, scope: !1180)
!1189 = !DILocalVariable(name: "tiny", scope: !1180, file: !1, line: 78, type: !103)
!1190 = !DILocation(line: 78, column: 11, scope: !1180)
!1191 = !DILocation(line: 82, column: 9, scope: !1192)
!1192 = distinct !DILexicalBlock(scope: !1180, file: !1, line: 82, column: 9)
!1193 = !DILocation(line: 82, column: 13, scope: !1192)
!1194 = !DILocation(line: 84, column: 31, scope: !1195)
!1195 = distinct !DILexicalBlock(scope: !1192, file: !1, line: 82, column: 19)
!1196 = !DILocalVariable(name: "__a", arg: 1, scope: !1197, file: !999, line: 215, type: !103)
!1197 = distinct !DISubprogram(name: "__fdiv_ru", linkageName: "_ZL9__fdiv_ruff", scope: !999, file: !999, line: 215, type: !114, scopeLine: 215, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1198 = !DILocation(line: 215, column: 34, scope: !1197, inlinedAt: !1199)
!1199 = distinct !DILocation(line: 84, column: 21, scope: !1195)
!1200 = !DILocalVariable(name: "__b", arg: 2, scope: !1197, file: !999, line: 215, type: !103)
!1201 = !DILocation(line: 215, column: 45, scope: !1197, inlinedAt: !1199)
!1202 = !DILocation(line: 216, column: 23, scope: !1197, inlinedAt: !1199)
!1203 = !DILocation(line: 216, column: 28, scope: !1197, inlinedAt: !1199)
!1204 = !DILocation(line: 216, column: 10, scope: !1197, inlinedAt: !1199)
!1205 = !DILocation(line: 84, column: 9, scope: !1195)
!1206 = !DILocation(line: 84, column: 19, scope: !1195)
!1207 = !DILocation(line: 85, column: 39, scope: !1195)
!1208 = !DILocation(line: 85, column: 26, scope: !1195)
!1209 = !DILocation(line: 85, column: 9, scope: !1195)
!1210 = !DILocation(line: 85, column: 24, scope: !1195)
!1211 = !DILocation(line: 86, column: 5, scope: !1195)
!1212 = !DILocation(line: 88, column: 9, scope: !1213)
!1213 = distinct !DILexicalBlock(scope: !1180, file: !1, line: 88, column: 9)
!1214 = !DILocation(line: 88, column: 13, scope: !1213)
!1215 = !DILocation(line: 89, column: 31, scope: !1216)
!1216 = distinct !DILexicalBlock(scope: !1213, file: !1, line: 88, column: 19)
!1217 = !DILocalVariable(name: "__a", arg: 1, scope: !1218, file: !999, line: 309, type: !103)
!1218 = distinct !DISubprogram(name: "__fmul_ru", linkageName: "_ZL9__fmul_ruff", scope: !999, file: !999, line: 309, type: !114, scopeLine: 309, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1219 = !DILocation(line: 309, column: 34, scope: !1218, inlinedAt: !1220)
!1220 = distinct !DILocation(line: 89, column: 21, scope: !1216)
!1221 = !DILocalVariable(name: "__b", arg: 2, scope: !1218, file: !999, line: 309, type: !103)
!1222 = !DILocation(line: 309, column: 45, scope: !1218, inlinedAt: !1220)
!1223 = !DILocation(line: 310, column: 23, scope: !1218, inlinedAt: !1220)
!1224 = !DILocation(line: 310, column: 28, scope: !1218, inlinedAt: !1220)
!1225 = !DILocation(line: 310, column: 10, scope: !1218, inlinedAt: !1220)
!1226 = !DILocation(line: 89, column: 9, scope: !1216)
!1227 = !DILocation(line: 89, column: 19, scope: !1216)
!1228 = !DILocation(line: 90, column: 39, scope: !1216)
!1229 = !DILocation(line: 90, column: 26, scope: !1216)
!1230 = !DILocation(line: 90, column: 9, scope: !1216)
!1231 = !DILocation(line: 90, column: 24, scope: !1216)
!1232 = !DILocation(line: 91, column: 5, scope: !1216)
!1233 = !DILocation(line: 93, column: 9, scope: !1234)
!1234 = distinct !DILexicalBlock(scope: !1180, file: !1, line: 93, column: 9)
!1235 = !DILocation(line: 93, column: 13, scope: !1234)
!1236 = !DILocation(line: 95, column: 32, scope: !1237)
!1237 = distinct !DILexicalBlock(scope: !1234, file: !1, line: 93, column: 19)
!1238 = !DILocation(line: 95, column: 31, scope: !1237)
!1239 = !DILocation(line: 309, column: 34, scope: !1218, inlinedAt: !1240)
!1240 = distinct !DILocation(line: 95, column: 21, scope: !1237)
!1241 = !DILocation(line: 309, column: 45, scope: !1218, inlinedAt: !1240)
!1242 = !DILocation(line: 310, column: 23, scope: !1218, inlinedAt: !1240)
!1243 = !DILocation(line: 310, column: 28, scope: !1218, inlinedAt: !1240)
!1244 = !DILocation(line: 310, column: 10, scope: !1218, inlinedAt: !1240)
!1245 = !DILocation(line: 95, column: 9, scope: !1237)
!1246 = !DILocation(line: 95, column: 19, scope: !1237)
!1247 = !DILocation(line: 96, column: 39, scope: !1237)
!1248 = !DILocation(line: 96, column: 26, scope: !1237)
!1249 = !DILocation(line: 96, column: 9, scope: !1237)
!1250 = !DILocation(line: 96, column: 24, scope: !1237)
!1251 = !DILocation(line: 97, column: 5, scope: !1237)
!1252 = !DILocation(line: 98, column: 1, scope: !1180)
!1253 = distinct !DISubprogram(name: "testUnderflow_RoundDown", linkageName: "_Z23testUnderflow_RoundDownPfPi", scope: !1, file: !1, line: 100, type: !979, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1254 = !DILocalVariable(name: "result", arg: 1, scope: !1253, file: !1, line: 100, type: !234)
!1255 = !DILocation(line: 100, column: 48, scope: !1253)
!1256 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1253, file: !1, line: 100, type: !162)
!1257 = !DILocation(line: 100, column: 61, scope: !1253)
!1258 = !DILocalVariable(name: "idx", scope: !1253, file: !1, line: 101, type: !98)
!1259 = !DILocation(line: 101, column: 9, scope: !1253)
!1260 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1261)
!1261 = distinct !DILocation(line: 101, column: 15, scope: !1253)
!1262 = !DILocalVariable(name: "tiny", scope: !1253, file: !1, line: 103, type: !103)
!1263 = !DILocation(line: 103, column: 11, scope: !1253)
!1264 = !DILocation(line: 107, column: 9, scope: !1265)
!1265 = distinct !DILexicalBlock(scope: !1253, file: !1, line: 107, column: 9)
!1266 = !DILocation(line: 107, column: 13, scope: !1265)
!1267 = !DILocation(line: 109, column: 31, scope: !1268)
!1268 = distinct !DILexicalBlock(scope: !1265, file: !1, line: 107, column: 19)
!1269 = !DILocalVariable(name: "__a", arg: 1, scope: !1270, file: !999, line: 209, type: !103)
!1270 = distinct !DISubprogram(name: "__fdiv_rd", linkageName: "_ZL9__fdiv_rdff", scope: !999, file: !999, line: 209, type: !114, scopeLine: 209, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1271 = !DILocation(line: 209, column: 34, scope: !1270, inlinedAt: !1272)
!1272 = distinct !DILocation(line: 109, column: 21, scope: !1268)
!1273 = !DILocalVariable(name: "__b", arg: 2, scope: !1270, file: !999, line: 209, type: !103)
!1274 = !DILocation(line: 209, column: 45, scope: !1270, inlinedAt: !1272)
!1275 = !DILocation(line: 210, column: 23, scope: !1270, inlinedAt: !1272)
!1276 = !DILocation(line: 210, column: 28, scope: !1270, inlinedAt: !1272)
!1277 = !DILocation(line: 210, column: 10, scope: !1270, inlinedAt: !1272)
!1278 = !DILocation(line: 109, column: 9, scope: !1268)
!1279 = !DILocation(line: 109, column: 19, scope: !1268)
!1280 = !DILocation(line: 110, column: 39, scope: !1268)
!1281 = !DILocation(line: 110, column: 26, scope: !1268)
!1282 = !DILocation(line: 110, column: 9, scope: !1268)
!1283 = !DILocation(line: 110, column: 24, scope: !1268)
!1284 = !DILocation(line: 111, column: 5, scope: !1268)
!1285 = !DILocation(line: 113, column: 9, scope: !1286)
!1286 = distinct !DILexicalBlock(scope: !1253, file: !1, line: 113, column: 9)
!1287 = !DILocation(line: 113, column: 13, scope: !1286)
!1288 = !DILocation(line: 115, column: 32, scope: !1289)
!1289 = distinct !DILexicalBlock(scope: !1286, file: !1, line: 113, column: 19)
!1290 = !DILocation(line: 115, column: 31, scope: !1289)
!1291 = !DILocalVariable(name: "__a", arg: 1, scope: !1292, file: !999, line: 303, type: !103)
!1292 = distinct !DISubprogram(name: "__fmul_rd", linkageName: "_ZL9__fmul_rdff", scope: !999, file: !999, line: 303, type: !114, scopeLine: 303, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!1293 = !DILocation(line: 303, column: 34, scope: !1292, inlinedAt: !1294)
!1294 = distinct !DILocation(line: 115, column: 21, scope: !1289)
!1295 = !DILocalVariable(name: "__b", arg: 2, scope: !1292, file: !999, line: 303, type: !103)
!1296 = !DILocation(line: 303, column: 45, scope: !1292, inlinedAt: !1294)
!1297 = !DILocation(line: 304, column: 23, scope: !1292, inlinedAt: !1294)
!1298 = !DILocation(line: 304, column: 28, scope: !1292, inlinedAt: !1294)
!1299 = !DILocation(line: 304, column: 10, scope: !1292, inlinedAt: !1294)
!1300 = !DILocation(line: 115, column: 9, scope: !1289)
!1301 = !DILocation(line: 115, column: 19, scope: !1289)
!1302 = !DILocation(line: 116, column: 39, scope: !1289)
!1303 = !DILocation(line: 116, column: 26, scope: !1289)
!1304 = !DILocation(line: 116, column: 9, scope: !1289)
!1305 = !DILocation(line: 116, column: 24, scope: !1289)
!1306 = !DILocation(line: 117, column: 5, scope: !1289)
!1307 = !DILocation(line: 119, column: 9, scope: !1308)
!1308 = distinct !DILexicalBlock(scope: !1253, file: !1, line: 119, column: 9)
!1309 = !DILocation(line: 119, column: 13, scope: !1308)
!1310 = !DILocation(line: 120, column: 32, scope: !1311)
!1311 = distinct !DILexicalBlock(scope: !1308, file: !1, line: 119, column: 19)
!1312 = !DILocation(line: 120, column: 31, scope: !1311)
!1313 = !DILocation(line: 303, column: 34, scope: !1292, inlinedAt: !1314)
!1314 = distinct !DILocation(line: 120, column: 21, scope: !1311)
!1315 = !DILocation(line: 303, column: 45, scope: !1292, inlinedAt: !1314)
!1316 = !DILocation(line: 304, column: 23, scope: !1292, inlinedAt: !1314)
!1317 = !DILocation(line: 304, column: 28, scope: !1292, inlinedAt: !1314)
!1318 = !DILocation(line: 304, column: 10, scope: !1292, inlinedAt: !1314)
!1319 = !DILocation(line: 120, column: 9, scope: !1311)
!1320 = !DILocation(line: 120, column: 19, scope: !1311)
!1321 = !DILocation(line: 121, column: 39, scope: !1311)
!1322 = !DILocation(line: 121, column: 26, scope: !1311)
!1323 = !DILocation(line: 121, column: 9, scope: !1311)
!1324 = !DILocation(line: 121, column: 24, scope: !1311)
!1325 = !DILocation(line: 122, column: 5, scope: !1311)
!1326 = !DILocation(line: 123, column: 1, scope: !1253)
