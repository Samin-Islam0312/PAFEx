; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/basic/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

%struct.float2 = type { float, float }

@fp_counters = addrspace(1) global [6 x i64] zeroinitializer, align 8

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
define dso_local ptx_kernel void @_Z24testUnderflow_OperationsPfPi(ptr noundef %result, ptr noundef %is_denorm) #2 !dbg !978 {
entry:
  %__a.addr.i68 = alloca float, align 4
  %__a.addr.i66 = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %__a.addr.i64 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denorm.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  %a = alloca float, align 4
  %b = alloca float, align 4
  %denorm = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !981, !DIExpression(), !982)
  store ptr %is_denorm, ptr %is_denorm.addr, align 8
    #dbg_declare(ptr %is_denorm.addr, !983, !DIExpression(), !984)
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
  %3 = bitcast float %2 to i32, !dbg !997
  %4 = bitcast float %2 to i32, !dbg !997
  %5 = and i32 %4, 2139095040, !dbg !997
  %6 = icmp eq i32 %5, 2139095040, !dbg !997
  %7 = and i32 %4, 8388607, !dbg !997
  %8 = icmp ne i32 %7, 0, !dbg !997
  %is_nan = and i1 %6, %8, !dbg !997
  %9 = and i32 %3, 4194304, !dbg !997
  %10 = icmp eq i32 %9, 0, !dbg !997
  %is_snan = and i1 %is_nan, %10, !dbg !997
  %11 = or i1 %is_snan, false, !dbg !997
  %12 = bitcast float %2 to i32, !dbg !997
  %13 = and i32 %12, 2147483647, !dbg !997
  %is_zero = icmp eq i32 %13, 0, !dbg !997
  %14 = and i1 %is_zero, false, !dbg !997
  %15 = bitcast float %2 to i32, !dbg !997
  %16 = and i32 %15, 2139095040, !dbg !997
  %17 = icmp eq i32 %16, 2139095040, !dbg !997
  %18 = and i32 %15, 8388607, !dbg !997
  %19 = icmp eq i32 %18, 0, !dbg !997
  %is_inf = and i1 %17, %19, !dbg !997
  %20 = and i1 %is_inf, false, !dbg !997
  %21 = or i1 %14, %20, !dbg !997
  %22 = or i1 %11, %21, !dbg !997
  br i1 %22, label %23, label %25, !dbg !997

23:                                               ; preds = %if.then
  %24 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !997
  br label %25, !dbg !997

25:                                               ; preds = %if.then, %23
  %26 = bitcast float %2 to i32, !dbg !997
  %27 = and i32 %26, 2139095040, !dbg !997
  %is_finite = icmp ne i32 %27, 2139095040, !dbg !997
  %28 = bitcast float %2 to i32, !dbg !997
  %29 = and i32 %28, 2147483647, !dbg !997
  %is_zero1 = icmp eq i32 %29, 0, !dbg !997
  %30 = xor i1 %is_zero1, true, !dbg !997
  %31 = and i1 %is_finite, %30, !dbg !997
  %divzero_cond = and i1 false, %31, !dbg !997
  br i1 %divzero_cond, label %32, label %34, !dbg !997

32:                                               ; preds = %25
  %33 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !997
  br label %34, !dbg !997

34:                                               ; preds = %25, %32
  %div = fdiv contract float %2, 1.000000e+02, !dbg !997
  %35 = bitcast float %2 to i32, !dbg !998
  %36 = and i32 %35, 2139095040, !dbg !998
  %is_finite2 = icmp ne i32 %36, 2139095040, !dbg !998
  %37 = and i1 true, %is_finite2, !dbg !998
  %38 = and i1 %37, true, !dbg !998
  %overflow_denom_nonzero = and i1 %38, true, !dbg !998
  %39 = bitcast float %div to i32, !dbg !998
  %40 = and i32 %39, 2139095040, !dbg !998
  %41 = icmp eq i32 %40, 2139095040, !dbg !998
  %42 = and i32 %39, 8388607, !dbg !998
  %43 = icmp eq i32 %42, 0, !dbg !998
  %is_inf3 = and i1 %41, %43, !dbg !998
  %44 = bitcast float %div to i32, !dbg !998
  %45 = and i32 %44, 2147483647, !dbg !998
  %is_maxfinite = icmp eq i32 %45, 2139095039, !dbg !998
  %46 = bitcast float %div to i32, !dbg !998
  %47 = and i32 %46, -2147483648, !dbg !998
  %48 = icmp eq i32 %47, 0, !dbg !998
  %49 = icmp ne i32 %47, 0, !dbg !998
  %is_pos_inf = and i1 %is_inf3, %48, !dbg !998
  %is_neg_inf = and i1 %is_inf3, %49, !dbg !998
  %is_pos_max = and i1 %is_maxfinite, %48, !dbg !998
  %is_neg_max = and i1 %is_maxfinite, %49, !dbg !998
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf3, !dbg !998
  br i1 %overflow_cond, label %50, label %52, !dbg !998

50:                                               ; preds = %34
  %51 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !998
  br label %52, !dbg !998

52:                                               ; preds = %34, %50
  %53 = bitcast float %2 to i32, !dbg !998
  %54 = and i32 %53, 2139095040, !dbg !998
  %55 = icmp eq i32 %54, 0, !dbg !998
  %56 = and i32 %53, 8388607, !dbg !998
  %57 = icmp ne i32 %56, 0, !dbg !998
  %is_subnormal = and i1 %55, %57, !dbg !998
  %58 = xor i1 %is_subnormal, true, !dbg !998
  %59 = and i1 true, %58, !dbg !998
  %60 = and i1 %59, true, !dbg !998
  %61 = bitcast float %div to i32, !dbg !998
  %62 = and i32 %61, 2139095040, !dbg !998
  %63 = icmp eq i32 %62, 0, !dbg !998
  %64 = and i32 %61, 8388607, !dbg !998
  %65 = icmp ne i32 %64, 0, !dbg !998
  %is_subnormal4 = and i1 %63, %65, !dbg !998
  %66 = bitcast float %div to i32, !dbg !998
  %67 = and i32 %66, 2147483647, !dbg !998
  %is_zero5 = icmp eq i32 %67, 0, !dbg !998
  %68 = bitcast float %2 to i32, !dbg !998
  %69 = and i32 %68, 2147483647, !dbg !998
  %is_zero6 = icmp eq i32 %69, 0, !dbg !998
  %70 = xor i1 %is_zero6, true, !dbg !998
  %71 = and i1 %70, true, !dbg !998
  %72 = and i1 %is_zero5, %71, !dbg !998
  %is_tiny = or i1 %is_subnormal4, %72, !dbg !998
  %underflow_cond = and i1 %60, %is_tiny, !dbg !998
  br i1 %underflow_cond, label %73, label %75, !dbg !998

73:                                               ; preds = %52
  %74 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !998
  br label %75, !dbg !998

75:                                               ; preds = %52, %73
  %76 = bitcast float %2 to i32, !dbg !998
  %77 = and i32 %76, 2139095040, !dbg !998
  %78 = icmp eq i32 %77, 0, !dbg !998
  %79 = and i32 %76, 8388607, !dbg !998
  %80 = icmp ne i32 %79, 0, !dbg !998
  %is_subnormal7 = and i1 %78, %80, !dbg !998
  %81 = xor i1 %is_subnormal7, true, !dbg !998
  %82 = and i1 true, %81, !dbg !998
  %83 = and i1 %82, true, !dbg !998
  %84 = bitcast float %div to i32, !dbg !998
  %85 = and i32 %84, 2139095040, !dbg !998
  %86 = icmp eq i32 %85, 0, !dbg !998
  %87 = and i32 %84, 8388607, !dbg !998
  %88 = icmp ne i32 %87, 0, !dbg !998
  %is_subnormal8 = and i1 %86, %88, !dbg !998
  %subnormal_cond = and i1 %83, %is_subnormal8, !dbg !998
  br i1 %subnormal_cond, label %89, label %91, !dbg !998

89:                                               ; preds = %75
  %90 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !998
  br label %91, !dbg !998

91:                                               ; preds = %75, %89
  %92 = load ptr, ptr %result.addr, align 8, !dbg !998
  %arrayidx = getelementptr inbounds float, ptr %92, i64 0, !dbg !998
  store float %div, ptr %arrayidx, align 4, !dbg !999
  %93 = load ptr, ptr %result.addr, align 8, !dbg !1000
  %arrayidx1 = getelementptr inbounds float, ptr %93, i64 0, !dbg !1000
  %94 = load float, ptr %arrayidx1, align 4, !dbg !1000
  %call2 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %94) #4, !dbg !1001
  %95 = zext i1 %call2 to i64, !dbg !1001
  %cond = select i1 %call2, i32 1, i32 0, !dbg !1001
  %96 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1002
  %arrayidx3 = getelementptr inbounds i32, ptr %96, i64 0, !dbg !1002
  store i32 %cond, ptr %arrayidx3, align 4, !dbg !1003
  br label %if.end, !dbg !1004

if.end:                                           ; preds = %91, %entry
  %97 = load i32, ptr %idx, align 4, !dbg !1005
  %cmp4 = icmp eq i32 %97, 1, !dbg !1007
  br i1 %cmp4, label %if.then5, label %if.end11, !dbg !1007

if.then5:                                         ; preds = %if.end
  %98 = load float, ptr %tiny, align 4, !dbg !1008
  %99 = bitcast float %98 to i32, !dbg !1010
  %100 = bitcast float %98 to i32, !dbg !1010
  %101 = and i32 %100, 2139095040, !dbg !1010
  %102 = icmp eq i32 %101, 2139095040, !dbg !1010
  %103 = and i32 %100, 8388607, !dbg !1010
  %104 = icmp ne i32 %103, 0, !dbg !1010
  %is_nan9 = and i1 %102, %104, !dbg !1010
  %105 = and i32 %99, 4194304, !dbg !1010
  %106 = icmp eq i32 %105, 0, !dbg !1010
  %is_snan10 = and i1 %is_nan9, %106, !dbg !1010
  %107 = or i1 %is_snan10, false, !dbg !1010
  %108 = bitcast float %98 to i32, !dbg !1010
  %109 = and i32 %108, 2147483647, !dbg !1010
  %is_zero11 = icmp eq i32 %109, 0, !dbg !1010
  %110 = and i1 %is_zero11, false, !dbg !1010
  %111 = bitcast float %98 to i32, !dbg !1010
  %112 = and i32 %111, 2139095040, !dbg !1010
  %113 = icmp eq i32 %112, 2139095040, !dbg !1010
  %114 = and i32 %111, 8388607, !dbg !1010
  %115 = icmp eq i32 %114, 0, !dbg !1010
  %is_inf12 = and i1 %113, %115, !dbg !1010
  %116 = and i1 %is_inf12, false, !dbg !1010
  %117 = or i1 %110, %116, !dbg !1010
  %118 = or i1 %107, %117, !dbg !1010
  br i1 %118, label %119, label %121, !dbg !1010

119:                                              ; preds = %if.then5
  %120 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1010
  br label %121, !dbg !1010

121:                                              ; preds = %if.then5, %119
  %mul = fmul contract float %98, 0x3F847AE140000000, !dbg !1010
  %122 = bitcast float %98 to i32, !dbg !1011
  %123 = and i32 %122, 2139095040, !dbg !1011
  %is_finite13 = icmp ne i32 %123, 2139095040, !dbg !1011
  %124 = and i1 true, %is_finite13, !dbg !1011
  %125 = and i1 %124, true, !dbg !1011
  %126 = bitcast float %mul to i32, !dbg !1011
  %127 = and i32 %126, 2139095040, !dbg !1011
  %128 = icmp eq i32 %127, 2139095040, !dbg !1011
  %129 = and i32 %126, 8388607, !dbg !1011
  %130 = icmp eq i32 %129, 0, !dbg !1011
  %is_inf14 = and i1 %128, %130, !dbg !1011
  %131 = bitcast float %mul to i32, !dbg !1011
  %132 = and i32 %131, 2147483647, !dbg !1011
  %is_maxfinite15 = icmp eq i32 %132, 2139095039, !dbg !1011
  %133 = bitcast float %mul to i32, !dbg !1011
  %134 = and i32 %133, -2147483648, !dbg !1011
  %135 = icmp eq i32 %134, 0, !dbg !1011
  %136 = icmp ne i32 %134, 0, !dbg !1011
  %is_pos_inf16 = and i1 %is_inf14, %135, !dbg !1011
  %is_neg_inf17 = and i1 %is_inf14, %136, !dbg !1011
  %is_pos_max18 = and i1 %is_maxfinite15, %135, !dbg !1011
  %is_neg_max19 = and i1 %is_maxfinite15, %136, !dbg !1011
  %overflow_cond20 = and i1 %125, %is_inf14, !dbg !1011
  br i1 %overflow_cond20, label %137, label %139, !dbg !1011

137:                                              ; preds = %121
  %138 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1011
  br label %139, !dbg !1011

139:                                              ; preds = %121, %137
  %140 = bitcast float %98 to i32, !dbg !1011
  %141 = and i32 %140, 2139095040, !dbg !1011
  %142 = icmp eq i32 %141, 0, !dbg !1011
  %143 = and i32 %140, 8388607, !dbg !1011
  %144 = icmp ne i32 %143, 0, !dbg !1011
  %is_subnormal21 = and i1 %142, %144, !dbg !1011
  %145 = xor i1 %is_subnormal21, true, !dbg !1011
  %146 = and i1 true, %145, !dbg !1011
  %147 = and i1 %146, true, !dbg !1011
  %148 = bitcast float %mul to i32, !dbg !1011
  %149 = and i32 %148, 2139095040, !dbg !1011
  %150 = icmp eq i32 %149, 0, !dbg !1011
  %151 = and i32 %148, 8388607, !dbg !1011
  %152 = icmp ne i32 %151, 0, !dbg !1011
  %is_subnormal22 = and i1 %150, %152, !dbg !1011
  %153 = bitcast float %mul to i32, !dbg !1011
  %154 = and i32 %153, 2147483647, !dbg !1011
  %is_zero23 = icmp eq i32 %154, 0, !dbg !1011
  %155 = bitcast float %98 to i32, !dbg !1011
  %156 = and i32 %155, 2147483647, !dbg !1011
  %is_zero24 = icmp eq i32 %156, 0, !dbg !1011
  %157 = xor i1 %is_zero24, true, !dbg !1011
  %158 = and i1 %157, true, !dbg !1011
  %159 = and i1 %is_zero23, %158, !dbg !1011
  %is_tiny25 = or i1 %is_subnormal22, %159, !dbg !1011
  %underflow_cond26 = and i1 %147, %is_tiny25, !dbg !1011
  br i1 %underflow_cond26, label %160, label %162, !dbg !1011

160:                                              ; preds = %139
  %161 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1011
  br label %162, !dbg !1011

162:                                              ; preds = %139, %160
  %163 = bitcast float %98 to i32, !dbg !1011
  %164 = and i32 %163, 2139095040, !dbg !1011
  %165 = icmp eq i32 %164, 0, !dbg !1011
  %166 = and i32 %163, 8388607, !dbg !1011
  %167 = icmp ne i32 %166, 0, !dbg !1011
  %is_subnormal27 = and i1 %165, %167, !dbg !1011
  %168 = xor i1 %is_subnormal27, true, !dbg !1011
  %169 = and i1 true, %168, !dbg !1011
  %170 = and i1 %169, true, !dbg !1011
  %171 = bitcast float %mul to i32, !dbg !1011
  %172 = and i32 %171, 2139095040, !dbg !1011
  %173 = icmp eq i32 %172, 0, !dbg !1011
  %174 = and i32 %171, 8388607, !dbg !1011
  %175 = icmp ne i32 %174, 0, !dbg !1011
  %is_subnormal28 = and i1 %173, %175, !dbg !1011
  %subnormal_cond29 = and i1 %170, %is_subnormal28, !dbg !1011
  br i1 %subnormal_cond29, label %176, label %178, !dbg !1011

176:                                              ; preds = %162
  %177 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1011
  br label %178, !dbg !1011

178:                                              ; preds = %162, %176
  %179 = load ptr, ptr %result.addr, align 8, !dbg !1011
  %arrayidx6 = getelementptr inbounds float, ptr %179, i64 1, !dbg !1011
  store float %mul, ptr %arrayidx6, align 4, !dbg !1012
  %180 = load ptr, ptr %result.addr, align 8, !dbg !1013
  %arrayidx7 = getelementptr inbounds float, ptr %180, i64 1, !dbg !1013
  %181 = load float, ptr %arrayidx7, align 4, !dbg !1013
  %call8 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %181) #4, !dbg !1014
  %182 = zext i1 %call8 to i64, !dbg !1014
  %cond9 = select i1 %call8, i32 1, i32 0, !dbg !1014
  %183 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1015
  %arrayidx10 = getelementptr inbounds i32, ptr %183, i64 1, !dbg !1015
  store i32 %cond9, ptr %arrayidx10, align 4, !dbg !1016
  br label %if.end11, !dbg !1017

if.end11:                                         ; preds = %178, %if.end
  %184 = load i32, ptr %idx, align 4, !dbg !1018
  %cmp12 = icmp eq i32 %184, 2, !dbg !1020
  br i1 %cmp12, label %if.then13, label %if.end19, !dbg !1020

if.then13:                                        ; preds = %if.end11
    #dbg_declare(ptr %a, !1021, !DIExpression(), !1023)
  store float 0x38119999A0000000, ptr %a, align 4, !dbg !1023
    #dbg_declare(ptr %b, !1024, !DIExpression(), !1025)
  store float 0x3810000000000000, ptr %b, align 4, !dbg !1025
  %185 = load float, ptr %a, align 4, !dbg !1026
  %186 = load float, ptr %b, align 4, !dbg !1027
  %187 = bitcast float %185 to i32, !dbg !1028
  %188 = bitcast float %185 to i32, !dbg !1028
  %189 = and i32 %188, 2139095040, !dbg !1028
  %190 = icmp eq i32 %189, 2139095040, !dbg !1028
  %191 = and i32 %188, 8388607, !dbg !1028
  %192 = icmp ne i32 %191, 0, !dbg !1028
  %is_nan30 = and i1 %190, %192, !dbg !1028
  %193 = and i32 %187, 4194304, !dbg !1028
  %194 = icmp eq i32 %193, 0, !dbg !1028
  %is_snan31 = and i1 %is_nan30, %194, !dbg !1028
  %195 = bitcast float %186 to i32, !dbg !1028
  %196 = bitcast float %186 to i32, !dbg !1028
  %197 = and i32 %196, 2139095040, !dbg !1028
  %198 = icmp eq i32 %197, 2139095040, !dbg !1028
  %199 = and i32 %196, 8388607, !dbg !1028
  %200 = icmp ne i32 %199, 0, !dbg !1028
  %is_nan32 = and i1 %198, %200, !dbg !1028
  %201 = and i32 %195, 4194304, !dbg !1028
  %202 = icmp eq i32 %201, 0, !dbg !1028
  %is_snan33 = and i1 %is_nan32, %202, !dbg !1028
  %203 = or i1 %is_snan31, %is_snan33, !dbg !1028
  %204 = bitcast float %185 to i32, !dbg !1028
  %205 = and i32 %204, 2139095040, !dbg !1028
  %206 = icmp eq i32 %205, 2139095040, !dbg !1028
  %207 = and i32 %204, 8388607, !dbg !1028
  %208 = icmp eq i32 %207, 0, !dbg !1028
  %is_inf34 = and i1 %206, %208, !dbg !1028
  %209 = bitcast float %186 to i32, !dbg !1028
  %210 = and i32 %209, 2139095040, !dbg !1028
  %211 = icmp eq i32 %210, 2139095040, !dbg !1028
  %212 = and i32 %209, 8388607, !dbg !1028
  %213 = icmp eq i32 %212, 0, !dbg !1028
  %is_inf35 = and i1 %211, %213, !dbg !1028
  %214 = and i1 %is_inf34, %is_inf35, !dbg !1028
  %215 = bitcast float %185 to i32, !dbg !1028
  %216 = bitcast float %186 to i32, !dbg !1028
  %217 = and i32 %215, -2147483648, !dbg !1028
  %218 = and i32 %216, -2147483648, !dbg !1028
  %219 = icmp eq i32 %217, %218, !dbg !1028
  %220 = and i1 %214, %219, !dbg !1028
  %221 = or i1 %203, %220, !dbg !1028
  br i1 %221, label %222, label %224, !dbg !1028

222:                                              ; preds = %if.then13
  %223 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1028
  br label %224, !dbg !1028

224:                                              ; preds = %if.then13, %222
  %sub = fsub contract float %185, %186, !dbg !1028
  %225 = bitcast float %185 to i32, !dbg !1029
  %226 = and i32 %225, 2139095040, !dbg !1029
  %is_finite36 = icmp ne i32 %226, 2139095040, !dbg !1029
  %227 = and i1 true, %is_finite36, !dbg !1029
  %228 = bitcast float %186 to i32, !dbg !1029
  %229 = and i32 %228, 2139095040, !dbg !1029
  %is_finite37 = icmp ne i32 %229, 2139095040, !dbg !1029
  %230 = and i1 %227, %is_finite37, !dbg !1029
  %231 = bitcast float %sub to i32, !dbg !1029
  %232 = and i32 %231, 2139095040, !dbg !1029
  %233 = icmp eq i32 %232, 2139095040, !dbg !1029
  %234 = and i32 %231, 8388607, !dbg !1029
  %235 = icmp eq i32 %234, 0, !dbg !1029
  %is_inf38 = and i1 %233, %235, !dbg !1029
  %236 = bitcast float %sub to i32, !dbg !1029
  %237 = and i32 %236, 2147483647, !dbg !1029
  %is_maxfinite39 = icmp eq i32 %237, 2139095039, !dbg !1029
  %238 = bitcast float %sub to i32, !dbg !1029
  %239 = and i32 %238, -2147483648, !dbg !1029
  %240 = icmp eq i32 %239, 0, !dbg !1029
  %241 = icmp ne i32 %239, 0, !dbg !1029
  %is_pos_inf40 = and i1 %is_inf38, %240, !dbg !1029
  %is_neg_inf41 = and i1 %is_inf38, %241, !dbg !1029
  %is_pos_max42 = and i1 %is_maxfinite39, %240, !dbg !1029
  %is_neg_max43 = and i1 %is_maxfinite39, %241, !dbg !1029
  %overflow_cond44 = and i1 %230, %is_inf38, !dbg !1029
  br i1 %overflow_cond44, label %242, label %244, !dbg !1029

242:                                              ; preds = %224
  %243 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1029
  br label %244, !dbg !1029

244:                                              ; preds = %224, %242
  %245 = bitcast float %185 to i32, !dbg !1029
  %246 = and i32 %245, 2139095040, !dbg !1029
  %247 = icmp eq i32 %246, 0, !dbg !1029
  %248 = and i32 %245, 8388607, !dbg !1029
  %249 = icmp ne i32 %248, 0, !dbg !1029
  %is_subnormal45 = and i1 %247, %249, !dbg !1029
  %250 = xor i1 %is_subnormal45, true, !dbg !1029
  %251 = and i1 true, %250, !dbg !1029
  %252 = bitcast float %186 to i32, !dbg !1029
  %253 = and i32 %252, 2139095040, !dbg !1029
  %254 = icmp eq i32 %253, 0, !dbg !1029
  %255 = and i32 %252, 8388607, !dbg !1029
  %256 = icmp ne i32 %255, 0, !dbg !1029
  %is_subnormal46 = and i1 %254, %256, !dbg !1029
  %257 = xor i1 %is_subnormal46, true, !dbg !1029
  %258 = and i1 %251, %257, !dbg !1029
  %259 = bitcast float %sub to i32, !dbg !1029
  %260 = and i32 %259, 2139095040, !dbg !1029
  %261 = icmp eq i32 %260, 0, !dbg !1029
  %262 = and i32 %259, 8388607, !dbg !1029
  %263 = icmp ne i32 %262, 0, !dbg !1029
  %is_subnormal47 = and i1 %261, %263, !dbg !1029
  %subnormal_cond48 = and i1 %258, %is_subnormal47, !dbg !1029
  br i1 %subnormal_cond48, label %264, label %266, !dbg !1029

264:                                              ; preds = %244
  %265 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1029
  br label %266, !dbg !1029

266:                                              ; preds = %244, %264
  %267 = load ptr, ptr %result.addr, align 8, !dbg !1029
  %arrayidx14 = getelementptr inbounds float, ptr %267, i64 2, !dbg !1029
  store float %sub, ptr %arrayidx14, align 4, !dbg !1030
  %268 = load ptr, ptr %result.addr, align 8, !dbg !1031
  %arrayidx15 = getelementptr inbounds float, ptr %268, i64 2, !dbg !1031
  %269 = load float, ptr %arrayidx15, align 4, !dbg !1031
  %call16 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %269) #4, !dbg !1032
  %270 = zext i1 %call16 to i64, !dbg !1032
  %cond17 = select i1 %call16, i32 1, i32 0, !dbg !1032
  %271 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1033
  %arrayidx18 = getelementptr inbounds i32, ptr %271, i64 2, !dbg !1033
  store i32 %cond17, ptr %arrayidx18, align 4, !dbg !1034
  br label %if.end19, !dbg !1035

if.end19:                                         ; preds = %266, %if.end11
  %272 = load i32, ptr %idx, align 4, !dbg !1036
  %cmp20 = icmp eq i32 %272, 3, !dbg !1038
  br i1 %cmp20, label %if.then21, label %if.end27, !dbg !1038

if.then21:                                        ; preds = %if.end19
    #dbg_declare(ptr %denorm, !1039, !DIExpression(), !1041)
  store float 0x37D9999A00000000, ptr %denorm, align 4, !dbg !1041
  %273 = load float, ptr %denorm, align 4, !dbg !1042
  %274 = load float, ptr %denorm, align 4, !dbg !1043
  %275 = bitcast float %273 to i32, !dbg !1044
  %276 = bitcast float %273 to i32, !dbg !1044
  %277 = and i32 %276, 2139095040, !dbg !1044
  %278 = icmp eq i32 %277, 2139095040, !dbg !1044
  %279 = and i32 %276, 8388607, !dbg !1044
  %280 = icmp ne i32 %279, 0, !dbg !1044
  %is_nan49 = and i1 %278, %280, !dbg !1044
  %281 = and i32 %275, 4194304, !dbg !1044
  %282 = icmp eq i32 %281, 0, !dbg !1044
  %is_snan50 = and i1 %is_nan49, %282, !dbg !1044
  %283 = bitcast float %274 to i32, !dbg !1044
  %284 = bitcast float %274 to i32, !dbg !1044
  %285 = and i32 %284, 2139095040, !dbg !1044
  %286 = icmp eq i32 %285, 2139095040, !dbg !1044
  %287 = and i32 %284, 8388607, !dbg !1044
  %288 = icmp ne i32 %287, 0, !dbg !1044
  %is_nan51 = and i1 %286, %288, !dbg !1044
  %289 = and i32 %283, 4194304, !dbg !1044
  %290 = icmp eq i32 %289, 0, !dbg !1044
  %is_snan52 = and i1 %is_nan51, %290, !dbg !1044
  %291 = or i1 %is_snan50, %is_snan52, !dbg !1044
  %292 = bitcast float %273 to i32, !dbg !1044
  %293 = and i32 %292, 2139095040, !dbg !1044
  %294 = icmp eq i32 %293, 2139095040, !dbg !1044
  %295 = and i32 %292, 8388607, !dbg !1044
  %296 = icmp eq i32 %295, 0, !dbg !1044
  %is_inf53 = and i1 %294, %296, !dbg !1044
  %297 = bitcast float %274 to i32, !dbg !1044
  %298 = and i32 %297, 2139095040, !dbg !1044
  %299 = icmp eq i32 %298, 2139095040, !dbg !1044
  %300 = and i32 %297, 8388607, !dbg !1044
  %301 = icmp eq i32 %300, 0, !dbg !1044
  %is_inf54 = and i1 %299, %301, !dbg !1044
  %302 = and i1 %is_inf53, %is_inf54, !dbg !1044
  %303 = bitcast float %273 to i32, !dbg !1044
  %304 = bitcast float %274 to i32, !dbg !1044
  %305 = and i32 %303, -2147483648, !dbg !1044
  %306 = and i32 %304, -2147483648, !dbg !1044
  %307 = icmp ne i32 %305, %306, !dbg !1044
  %308 = and i1 %302, %307, !dbg !1044
  %309 = or i1 %291, %308, !dbg !1044
  br i1 %309, label %310, label %312, !dbg !1044

310:                                              ; preds = %if.then21
  %311 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1044
  br label %312, !dbg !1044

312:                                              ; preds = %if.then21, %310
  %add = fadd contract float %273, %274, !dbg !1044
  %313 = bitcast float %273 to i32, !dbg !1045
  %314 = and i32 %313, 2139095040, !dbg !1045
  %is_finite55 = icmp ne i32 %314, 2139095040, !dbg !1045
  %315 = and i1 true, %is_finite55, !dbg !1045
  %316 = bitcast float %274 to i32, !dbg !1045
  %317 = and i32 %316, 2139095040, !dbg !1045
  %is_finite56 = icmp ne i32 %317, 2139095040, !dbg !1045
  %318 = and i1 %315, %is_finite56, !dbg !1045
  %319 = bitcast float %add to i32, !dbg !1045
  %320 = and i32 %319, 2139095040, !dbg !1045
  %321 = icmp eq i32 %320, 2139095040, !dbg !1045
  %322 = and i32 %319, 8388607, !dbg !1045
  %323 = icmp eq i32 %322, 0, !dbg !1045
  %is_inf57 = and i1 %321, %323, !dbg !1045
  %324 = bitcast float %add to i32, !dbg !1045
  %325 = and i32 %324, 2147483647, !dbg !1045
  %is_maxfinite58 = icmp eq i32 %325, 2139095039, !dbg !1045
  %326 = bitcast float %add to i32, !dbg !1045
  %327 = and i32 %326, -2147483648, !dbg !1045
  %328 = icmp eq i32 %327, 0, !dbg !1045
  %329 = icmp ne i32 %327, 0, !dbg !1045
  %is_pos_inf59 = and i1 %is_inf57, %328, !dbg !1045
  %is_neg_inf60 = and i1 %is_inf57, %329, !dbg !1045
  %is_pos_max61 = and i1 %is_maxfinite58, %328, !dbg !1045
  %is_neg_max62 = and i1 %is_maxfinite58, %329, !dbg !1045
  %overflow_cond63 = and i1 %318, %is_inf57, !dbg !1045
  br i1 %overflow_cond63, label %330, label %332, !dbg !1045

330:                                              ; preds = %312
  %331 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1045
  br label %332, !dbg !1045

332:                                              ; preds = %312, %330
  %333 = bitcast float %273 to i32, !dbg !1045
  %334 = and i32 %333, 2139095040, !dbg !1045
  %335 = icmp eq i32 %334, 0, !dbg !1045
  %336 = and i32 %333, 8388607, !dbg !1045
  %337 = icmp ne i32 %336, 0, !dbg !1045
  %is_subnormal64 = and i1 %335, %337, !dbg !1045
  %338 = xor i1 %is_subnormal64, true, !dbg !1045
  %339 = and i1 true, %338, !dbg !1045
  %340 = bitcast float %274 to i32, !dbg !1045
  %341 = and i32 %340, 2139095040, !dbg !1045
  %342 = icmp eq i32 %341, 0, !dbg !1045
  %343 = and i32 %340, 8388607, !dbg !1045
  %344 = icmp ne i32 %343, 0, !dbg !1045
  %is_subnormal65 = and i1 %342, %344, !dbg !1045
  %345 = xor i1 %is_subnormal65, true, !dbg !1045
  %346 = and i1 %339, %345, !dbg !1045
  %347 = bitcast float %add to i32, !dbg !1045
  %348 = and i32 %347, 2139095040, !dbg !1045
  %349 = icmp eq i32 %348, 0, !dbg !1045
  %350 = and i32 %347, 8388607, !dbg !1045
  %351 = icmp ne i32 %350, 0, !dbg !1045
  %is_subnormal66 = and i1 %349, %351, !dbg !1045
  %subnormal_cond67 = and i1 %346, %is_subnormal66, !dbg !1045
  br i1 %subnormal_cond67, label %352, label %354, !dbg !1045

352:                                              ; preds = %332
  %353 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1045
  br label %354, !dbg !1045

354:                                              ; preds = %332, %352
  %355 = load ptr, ptr %result.addr, align 8, !dbg !1045
  %arrayidx22 = getelementptr inbounds float, ptr %355, i64 3, !dbg !1045
  store float %add, ptr %arrayidx22, align 4, !dbg !1046
  %356 = load ptr, ptr %result.addr, align 8, !dbg !1047
  %arrayidx23 = getelementptr inbounds float, ptr %356, i64 3, !dbg !1047
  %357 = load float, ptr %arrayidx23, align 4, !dbg !1047
  %call24 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %357) #4, !dbg !1048
  %358 = zext i1 %call24 to i64, !dbg !1048
  %cond25 = select i1 %call24, i32 1, i32 0, !dbg !1048
  %359 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1049
  %arrayidx26 = getelementptr inbounds i32, ptr %359, i64 3, !dbg !1049
  store i32 %cond25, ptr %arrayidx26, align 4, !dbg !1050
  br label %if.end27, !dbg !1051

if.end27:                                         ; preds = %354, %if.end19
  %360 = load i32, ptr %idx, align 4, !dbg !1052
  %cmp28 = icmp eq i32 %360, 4, !dbg !1054
  br i1 %cmp28, label %if.then29, label %if.end36, !dbg !1054

if.then29:                                        ; preds = %if.end27
  %361 = load float, ptr %tiny, align 4, !dbg !1055
  store float %361, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1057, !DIExpression(), !1058)
  %362 = load float, ptr %__a.addr.i, align 4, !dbg !1060
  %363 = bitcast float %362 to i32, !dbg !1061
  %364 = bitcast float %362 to i32, !dbg !1061
  %365 = and i32 %364, 2139095040, !dbg !1061
  %366 = icmp eq i32 %365, 2139095040, !dbg !1061
  %367 = and i32 %364, 8388607, !dbg !1061
  %368 = icmp ne i32 %367, 0, !dbg !1061
  %is_nan68 = and i1 %366, %368, !dbg !1061
  %369 = and i32 %363, 4194304, !dbg !1061
  %370 = icmp eq i32 %369, 0, !dbg !1061
  %is_snan69 = and i1 %is_nan68, %370, !dbg !1061
  %371 = bitcast float %362 to i32, !dbg !1061
  %372 = and i32 %371, -2147483648, !dbg !1061
  %is_neg = icmp ne i32 %372, 0, !dbg !1061
  %373 = or i1 %is_snan69, %is_neg, !dbg !1061
  br i1 %373, label %374, label %376, !dbg !1061

374:                                              ; preds = %if.then29
  %375 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1061
  br label %376, !dbg !1061

376:                                              ; preds = %if.then29, %374
  %377 = call float @llvm.nvvm.sqrt.approx.f(float %362) #5, !dbg !1061
  %378 = load ptr, ptr %result.addr, align 8, !dbg !1062
  %arrayidx31 = getelementptr inbounds float, ptr %378, i64 4, !dbg !1062
  store float %377, ptr %arrayidx31, align 4, !dbg !1063
  %379 = load ptr, ptr %result.addr, align 8, !dbg !1064
  %arrayidx32 = getelementptr inbounds float, ptr %379, i64 4, !dbg !1064
  %380 = load float, ptr %arrayidx32, align 4, !dbg !1064
  %call33 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %380) #4, !dbg !1065
  %381 = zext i1 %call33 to i64, !dbg !1065
  %cond34 = select i1 %call33, i32 1, i32 0, !dbg !1065
  %382 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1066
  %arrayidx35 = getelementptr inbounds i32, ptr %382, i64 4, !dbg !1066
  store i32 %cond34, ptr %arrayidx35, align 4, !dbg !1067
  br label %if.end36, !dbg !1068

if.end36:                                         ; preds = %376, %if.end27
  %383 = load i32, ptr %idx, align 4, !dbg !1069
  %cmp37 = icmp eq i32 %383, 5, !dbg !1071
  br i1 %cmp37, label %if.then38, label %if.end45, !dbg !1071

if.then38:                                        ; preds = %if.end36
  store float -1.000000e+02, ptr %__a.addr.i64, align 4
    #dbg_declare(ptr %__a.addr.i64, !1072, !DIExpression(), !1073)
  %384 = load float, ptr %__a.addr.i64, align 4, !dbg !1076
  %385 = bitcast float %384 to i32, !dbg !1077
  %386 = bitcast float %384 to i32, !dbg !1077
  %387 = and i32 %386, 2139095040, !dbg !1077
  %388 = icmp eq i32 %387, 2139095040, !dbg !1077
  %389 = and i32 %386, 8388607, !dbg !1077
  %390 = icmp ne i32 %389, 0, !dbg !1077
  %is_nan70 = and i1 %388, %390, !dbg !1077
  %391 = and i32 %385, 4194304, !dbg !1077
  %392 = icmp eq i32 %391, 0, !dbg !1077
  %is_snan71 = and i1 %is_nan70, %392, !dbg !1077
  %393 = or i1 %is_snan71, false, !dbg !1077
  %394 = or i1 %393, false, !dbg !1077
  %395 = bitcast float %384 to i32, !dbg !1077
  %396 = and i32 %395, 2147483647, !dbg !1077
  %is_zero72 = icmp eq i32 %396, 0, !dbg !1077
  %397 = and i1 %is_zero72, false, !dbg !1077
  %398 = bitcast float %384 to i32, !dbg !1077
  %399 = and i32 %398, 2139095040, !dbg !1077
  %400 = icmp eq i32 %399, 2139095040, !dbg !1077
  %401 = and i32 %398, 8388607, !dbg !1077
  %402 = icmp eq i32 %401, 0, !dbg !1077
  %is_inf73 = and i1 %400, %402, !dbg !1077
  %403 = and i1 %is_inf73, false, !dbg !1077
  %404 = or i1 %397, %403, !dbg !1077
  %405 = or i1 %394, %404, !dbg !1077
  br i1 %405, label %406, label %408, !dbg !1077

406:                                              ; preds = %if.then38
  %407 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %408, !dbg !1077

408:                                              ; preds = %if.then38, %406
  %409 = call float @llvm.nvvm.fma.rn.f(float %384, float 0x3F777313A0000000, float 5.000000e-01) #5, !dbg !1077
  %410 = bitcast float %384 to i32, !dbg !1077
  %411 = and i32 %410, 2139095040, !dbg !1077
  %is_finite74 = icmp ne i32 %411, 2139095040, !dbg !1077
  %412 = and i1 true, %is_finite74, !dbg !1077
  %413 = and i1 %412, true, !dbg !1077
  %414 = bitcast float %409 to i32, !dbg !1077
  %415 = and i32 %414, 2139095040, !dbg !1077
  %416 = icmp eq i32 %415, 2139095040, !dbg !1077
  %417 = and i32 %414, 8388607, !dbg !1077
  %418 = icmp eq i32 %417, 0, !dbg !1077
  %is_inf75 = and i1 %416, %418, !dbg !1077
  %419 = bitcast float %409 to i32, !dbg !1077
  %420 = and i32 %419, 2147483647, !dbg !1077
  %is_maxfinite76 = icmp eq i32 %420, 2139095039, !dbg !1077
  %421 = bitcast float %409 to i32, !dbg !1077
  %422 = and i32 %421, -2147483648, !dbg !1077
  %423 = icmp eq i32 %422, 0, !dbg !1077
  %424 = icmp ne i32 %422, 0, !dbg !1077
  %is_pos_inf77 = and i1 %is_inf75, %423, !dbg !1077
  %is_neg_inf78 = and i1 %is_inf75, %424, !dbg !1077
  %is_pos_max79 = and i1 %is_maxfinite76, %423, !dbg !1077
  %is_neg_max80 = and i1 %is_maxfinite76, %424, !dbg !1077
  %overflow_cond81 = and i1 %413, %is_inf75, !dbg !1077
  br i1 %overflow_cond81, label %425, label %427, !dbg !1077

425:                                              ; preds = %408
  %426 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %427, !dbg !1077

427:                                              ; preds = %408, %425
  %428 = bitcast float %384 to i32, !dbg !1077
  %429 = and i32 %428, 2139095040, !dbg !1077
  %430 = icmp eq i32 %429, 0, !dbg !1077
  %431 = and i32 %428, 8388607, !dbg !1077
  %432 = icmp ne i32 %431, 0, !dbg !1077
  %is_subnormal82 = and i1 %430, %432, !dbg !1077
  %433 = xor i1 %is_subnormal82, true, !dbg !1077
  %434 = and i1 true, %433, !dbg !1077
  %435 = and i1 %434, true, !dbg !1077
  %436 = and i1 %435, true, !dbg !1077
  %437 = bitcast float %409 to i32, !dbg !1077
  %438 = and i32 %437, 2139095040, !dbg !1077
  %439 = icmp eq i32 %438, 0, !dbg !1077
  %440 = and i32 %437, 8388607, !dbg !1077
  %441 = icmp ne i32 %440, 0, !dbg !1077
  %is_subnormal83 = and i1 %439, %441, !dbg !1077
  %442 = bitcast float %409 to i32, !dbg !1077
  %443 = and i32 %442, 2147483647, !dbg !1077
  %is_zero84 = icmp eq i32 %443, 0, !dbg !1077
  %444 = bitcast float %384 to i32, !dbg !1077
  %445 = and i32 %444, 2147483647, !dbg !1077
  %is_zero85 = icmp eq i32 %445, 0, !dbg !1077
  %446 = xor i1 %is_zero85, true, !dbg !1077
  %447 = and i1 %446, true, !dbg !1077
  %448 = and i1 %447, true, !dbg !1077
  %449 = and i1 %is_zero84, %448, !dbg !1077
  %is_tiny86 = or i1 %is_subnormal83, %449, !dbg !1077
  %underflow_cond87 = and i1 %436, %is_tiny86, !dbg !1077
  br i1 %underflow_cond87, label %450, label %452, !dbg !1077

450:                                              ; preds = %427
  %451 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1077
  br label %452, !dbg !1077

452:                                              ; preds = %427, %450
  %453 = bitcast float %384 to i32, !dbg !1077
  %454 = and i32 %453, 2139095040, !dbg !1077
  %455 = icmp eq i32 %454, 0, !dbg !1077
  %456 = and i32 %453, 8388607, !dbg !1077
  %457 = icmp ne i32 %456, 0, !dbg !1077
  %is_subnormal88 = and i1 %455, %457, !dbg !1077
  %458 = xor i1 %is_subnormal88, true, !dbg !1077
  %459 = and i1 true, %458, !dbg !1077
  %460 = and i1 %459, true, !dbg !1077
  %461 = and i1 %460, true, !dbg !1077
  %462 = bitcast float %409 to i32, !dbg !1077
  %463 = and i32 %462, 2139095040, !dbg !1077
  %464 = icmp eq i32 %463, 0, !dbg !1077
  %465 = and i32 %462, 8388607, !dbg !1077
  %466 = icmp ne i32 %465, 0, !dbg !1077
  %is_subnormal89 = and i1 %464, %466, !dbg !1077
  %subnormal_cond90 = and i1 %461, %is_subnormal89, !dbg !1077
  br i1 %subnormal_cond90, label %467, label %469, !dbg !1077

467:                                              ; preds = %452
  %468 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %469, !dbg !1077

469:                                              ; preds = %452, %467
  %470 = call float @llvm.nvvm.saturate.f(float %409) #5, !dbg !1077
  %471 = bitcast float %470 to i32, !dbg !1077
  %472 = bitcast float %470 to i32, !dbg !1077
  %473 = and i32 %472, 2139095040, !dbg !1077
  %474 = icmp eq i32 %473, 2139095040, !dbg !1077
  %475 = and i32 %472, 8388607, !dbg !1077
  %476 = icmp ne i32 %475, 0, !dbg !1077
  %is_nan91 = and i1 %474, %476, !dbg !1077
  %477 = and i32 %471, 4194304, !dbg !1077
  %478 = icmp eq i32 %477, 0, !dbg !1077
  %is_snan92 = and i1 %is_nan91, %478, !dbg !1077
  %479 = or i1 %is_snan92, false, !dbg !1077
  %480 = or i1 %479, false, !dbg !1077
  %481 = bitcast float %470 to i32, !dbg !1077
  %482 = and i32 %481, 2147483647, !dbg !1077
  %is_zero93 = icmp eq i32 %482, 0, !dbg !1077
  %483 = and i1 %is_zero93, false, !dbg !1077
  %484 = bitcast float %470 to i32, !dbg !1077
  %485 = and i32 %484, 2139095040, !dbg !1077
  %486 = icmp eq i32 %485, 2139095040, !dbg !1077
  %487 = and i32 %484, 8388607, !dbg !1077
  %488 = icmp eq i32 %487, 0, !dbg !1077
  %is_inf94 = and i1 %486, %488, !dbg !1077
  %489 = and i1 %is_inf94, false, !dbg !1077
  %490 = or i1 %483, %489, !dbg !1077
  %491 = or i1 %480, %490, !dbg !1077
  br i1 %491, label %492, label %494, !dbg !1077

492:                                              ; preds = %469
  %493 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %494, !dbg !1077

494:                                              ; preds = %469, %492
  %495 = call float @llvm.nvvm.fma.rm.f(float %470, float 2.520000e+02, float 0x4168000020000000) #5, !dbg !1077
  %496 = bitcast float %470 to i32, !dbg !1077
  %497 = and i32 %496, 2139095040, !dbg !1077
  %is_finite95 = icmp ne i32 %497, 2139095040, !dbg !1077
  %498 = and i1 true, %is_finite95, !dbg !1077
  %499 = and i1 %498, true, !dbg !1077
  %500 = bitcast float %495 to i32, !dbg !1077
  %501 = and i32 %500, 2139095040, !dbg !1077
  %502 = icmp eq i32 %501, 2139095040, !dbg !1077
  %503 = and i32 %500, 8388607, !dbg !1077
  %504 = icmp eq i32 %503, 0, !dbg !1077
  %is_inf96 = and i1 %502, %504, !dbg !1077
  %505 = bitcast float %495 to i32, !dbg !1077
  %506 = and i32 %505, 2147483647, !dbg !1077
  %is_maxfinite97 = icmp eq i32 %506, 2139095039, !dbg !1077
  %507 = bitcast float %495 to i32, !dbg !1077
  %508 = and i32 %507, -2147483648, !dbg !1077
  %509 = icmp eq i32 %508, 0, !dbg !1077
  %510 = icmp ne i32 %508, 0, !dbg !1077
  %is_pos_inf98 = and i1 %is_inf96, %509, !dbg !1077
  %is_neg_inf99 = and i1 %is_inf96, %510, !dbg !1077
  %is_pos_max100 = and i1 %is_maxfinite97, %509, !dbg !1077
  %is_neg_max101 = and i1 %is_maxfinite97, %510, !dbg !1077
  %overflow_rm = or i1 %is_neg_inf99, %is_pos_max100, !dbg !1077
  %overflow_cond102 = and i1 %499, %overflow_rm, !dbg !1077
  br i1 %overflow_cond102, label %511, label %513, !dbg !1077

511:                                              ; preds = %494
  %512 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %513, !dbg !1077

513:                                              ; preds = %494, %511
  %514 = bitcast float %470 to i32, !dbg !1077
  %515 = and i32 %514, 2139095040, !dbg !1077
  %516 = icmp eq i32 %515, 0, !dbg !1077
  %517 = and i32 %514, 8388607, !dbg !1077
  %518 = icmp ne i32 %517, 0, !dbg !1077
  %is_subnormal103 = and i1 %516, %518, !dbg !1077
  %519 = xor i1 %is_subnormal103, true, !dbg !1077
  %520 = and i1 true, %519, !dbg !1077
  %521 = and i1 %520, true, !dbg !1077
  %522 = and i1 %521, true, !dbg !1077
  %523 = bitcast float %495 to i32, !dbg !1077
  %524 = and i32 %523, 2139095040, !dbg !1077
  %525 = icmp eq i32 %524, 0, !dbg !1077
  %526 = and i32 %523, 8388607, !dbg !1077
  %527 = icmp ne i32 %526, 0, !dbg !1077
  %is_subnormal104 = and i1 %525, %527, !dbg !1077
  %528 = bitcast float %495 to i32, !dbg !1077
  %529 = and i32 %528, 2147483647, !dbg !1077
  %is_zero105 = icmp eq i32 %529, 0, !dbg !1077
  %530 = bitcast float %470 to i32, !dbg !1077
  %531 = and i32 %530, 2147483647, !dbg !1077
  %is_zero106 = icmp eq i32 %531, 0, !dbg !1077
  %532 = xor i1 %is_zero106, true, !dbg !1077
  %533 = and i1 %532, true, !dbg !1077
  %534 = and i1 %533, true, !dbg !1077
  %535 = and i1 %is_zero105, %534, !dbg !1077
  %is_tiny107 = or i1 %is_subnormal104, %535, !dbg !1077
  %underflow_cond108 = and i1 %522, %is_tiny107, !dbg !1077
  br i1 %underflow_cond108, label %536, label %538, !dbg !1077

536:                                              ; preds = %513
  %537 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1077
  br label %538, !dbg !1077

538:                                              ; preds = %513, %536
  %539 = bitcast float %470 to i32, !dbg !1077
  %540 = and i32 %539, 2139095040, !dbg !1077
  %541 = icmp eq i32 %540, 0, !dbg !1077
  %542 = and i32 %539, 8388607, !dbg !1077
  %543 = icmp ne i32 %542, 0, !dbg !1077
  %is_subnormal109 = and i1 %541, %543, !dbg !1077
  %544 = xor i1 %is_subnormal109, true, !dbg !1077
  %545 = and i1 true, %544, !dbg !1077
  %546 = and i1 %545, true, !dbg !1077
  %547 = and i1 %546, true, !dbg !1077
  %548 = bitcast float %495 to i32, !dbg !1077
  %549 = and i32 %548, 2139095040, !dbg !1077
  %550 = icmp eq i32 %549, 0, !dbg !1077
  %551 = and i32 %548, 8388607, !dbg !1077
  %552 = icmp ne i32 %551, 0, !dbg !1077
  %is_subnormal110 = and i1 %550, %552, !dbg !1077
  %subnormal_cond111 = and i1 %547, %is_subnormal110, !dbg !1077
  br i1 %subnormal_cond111, label %553, label %555, !dbg !1077

553:                                              ; preds = %538
  %554 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %555, !dbg !1077

555:                                              ; preds = %538, %553
  %556 = bitcast float %495 to i32, !dbg !1077
  %557 = bitcast float %495 to i32, !dbg !1077
  %558 = and i32 %557, 2139095040, !dbg !1077
  %559 = icmp eq i32 %558, 2139095040, !dbg !1077
  %560 = and i32 %557, 8388607, !dbg !1077
  %561 = icmp ne i32 %560, 0, !dbg !1077
  %is_nan112 = and i1 %559, %561, !dbg !1077
  %562 = and i32 %556, 4194304, !dbg !1077
  %563 = icmp eq i32 %562, 0, !dbg !1077
  %is_snan113 = and i1 %is_nan112, %563, !dbg !1077
  %564 = or i1 %is_snan113, false, !dbg !1077
  %565 = bitcast float %495 to i32, !dbg !1077
  %566 = and i32 %565, 2139095040, !dbg !1077
  %567 = icmp eq i32 %566, 2139095040, !dbg !1077
  %568 = and i32 %565, 8388607, !dbg !1077
  %569 = icmp eq i32 %568, 0, !dbg !1077
  %is_inf114 = and i1 %567, %569, !dbg !1077
  %570 = and i1 %is_inf114, false, !dbg !1077
  %571 = bitcast float %495 to i32, !dbg !1077
  %572 = and i32 %571, -2147483648, !dbg !1077
  %573 = icmp eq i32 %572, 0, !dbg !1077
  %574 = and i1 %570, %573, !dbg !1077
  %575 = or i1 %564, %574, !dbg !1077
  br i1 %575, label %576, label %578, !dbg !1077

576:                                              ; preds = %555
  %577 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %578, !dbg !1077

578:                                              ; preds = %555, %576
  %579 = fsub float %495, 0x4168000FE0000000, !dbg !1077
  %580 = bitcast float %495 to i32, !dbg !1077
  %581 = and i32 %580, 2139095040, !dbg !1077
  %is_finite115 = icmp ne i32 %581, 2139095040, !dbg !1077
  %582 = and i1 true, %is_finite115, !dbg !1077
  %583 = and i1 %582, true, !dbg !1077
  %584 = bitcast float %579 to i32, !dbg !1077
  %585 = and i32 %584, 2139095040, !dbg !1077
  %586 = icmp eq i32 %585, 2139095040, !dbg !1077
  %587 = and i32 %584, 8388607, !dbg !1077
  %588 = icmp eq i32 %587, 0, !dbg !1077
  %is_inf116 = and i1 %586, %588, !dbg !1077
  %589 = bitcast float %579 to i32, !dbg !1077
  %590 = and i32 %589, 2147483647, !dbg !1077
  %is_maxfinite117 = icmp eq i32 %590, 2139095039, !dbg !1077
  %591 = bitcast float %579 to i32, !dbg !1077
  %592 = and i32 %591, -2147483648, !dbg !1077
  %593 = icmp eq i32 %592, 0, !dbg !1077
  %594 = icmp ne i32 %592, 0, !dbg !1077
  %is_pos_inf118 = and i1 %is_inf116, %593, !dbg !1077
  %is_neg_inf119 = and i1 %is_inf116, %594, !dbg !1077
  %is_pos_max120 = and i1 %is_maxfinite117, %593, !dbg !1077
  %is_neg_max121 = and i1 %is_maxfinite117, %594, !dbg !1077
  %overflow_cond122 = and i1 %583, %is_inf116, !dbg !1077
  br i1 %overflow_cond122, label %595, label %597, !dbg !1077

595:                                              ; preds = %578
  %596 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %597, !dbg !1077

597:                                              ; preds = %578, %595
  %598 = bitcast float %495 to i32, !dbg !1077
  %599 = and i32 %598, 2139095040, !dbg !1077
  %600 = icmp eq i32 %599, 0, !dbg !1077
  %601 = and i32 %598, 8388607, !dbg !1077
  %602 = icmp ne i32 %601, 0, !dbg !1077
  %is_subnormal123 = and i1 %600, %602, !dbg !1077
  %603 = xor i1 %is_subnormal123, true, !dbg !1077
  %604 = and i1 true, %603, !dbg !1077
  %605 = and i1 %604, true, !dbg !1077
  %606 = bitcast float %579 to i32, !dbg !1077
  %607 = and i32 %606, 2139095040, !dbg !1077
  %608 = icmp eq i32 %607, 0, !dbg !1077
  %609 = and i32 %606, 8388607, !dbg !1077
  %610 = icmp ne i32 %609, 0, !dbg !1077
  %is_subnormal124 = and i1 %608, %610, !dbg !1077
  %subnormal_cond125 = and i1 %605, %is_subnormal124, !dbg !1077
  br i1 %subnormal_cond125, label %611, label %613, !dbg !1077

611:                                              ; preds = %597
  %612 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %613, !dbg !1077

613:                                              ; preds = %597, %611
  %614 = bitcast float %579 to i32, !dbg !1077
  %615 = bitcast float %579 to i32, !dbg !1077
  %616 = and i32 %615, 2139095040, !dbg !1077
  %617 = icmp eq i32 %616, 2139095040, !dbg !1077
  %618 = and i32 %615, 8388607, !dbg !1077
  %619 = icmp ne i32 %618, 0, !dbg !1077
  %is_nan126 = and i1 %617, %619, !dbg !1077
  %620 = and i32 %614, 4194304, !dbg !1077
  %621 = icmp eq i32 %620, 0, !dbg !1077
  %is_snan127 = and i1 %is_nan126, %621, !dbg !1077
  %622 = or i1 false, %is_snan127, !dbg !1077
  %623 = bitcast float %579 to i32, !dbg !1077
  %624 = and i32 %623, 2139095040, !dbg !1077
  %625 = icmp eq i32 %624, 2139095040, !dbg !1077
  %626 = and i32 %623, 8388607, !dbg !1077
  %627 = icmp eq i32 %626, 0, !dbg !1077
  %is_inf128 = and i1 %625, %627, !dbg !1077
  %628 = and i1 false, %is_inf128, !dbg !1077
  %629 = bitcast float %579 to i32, !dbg !1077
  %630 = and i32 %629, -2147483648, !dbg !1077
  %631 = icmp eq i32 -2147483648, %630, !dbg !1077
  %632 = and i1 %628, %631, !dbg !1077
  %633 = or i1 %622, %632, !dbg !1077
  br i1 %633, label %634, label %636, !dbg !1077

634:                                              ; preds = %613
  %635 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %636, !dbg !1077

636:                                              ; preds = %613, %634
  %637 = fsub float -0.000000e+00, %579, !dbg !1077
  %638 = bitcast float %579 to i32, !dbg !1077
  %639 = and i32 %638, 2139095040, !dbg !1077
  %is_finite129 = icmp ne i32 %639, 2139095040, !dbg !1077
  %640 = and i1 true, %is_finite129, !dbg !1077
  %641 = bitcast float %637 to i32, !dbg !1077
  %642 = and i32 %641, 2139095040, !dbg !1077
  %643 = icmp eq i32 %642, 2139095040, !dbg !1077
  %644 = and i32 %641, 8388607, !dbg !1077
  %645 = icmp eq i32 %644, 0, !dbg !1077
  %is_inf130 = and i1 %643, %645, !dbg !1077
  %646 = bitcast float %637 to i32, !dbg !1077
  %647 = and i32 %646, 2147483647, !dbg !1077
  %is_maxfinite131 = icmp eq i32 %647, 2139095039, !dbg !1077
  %648 = bitcast float %637 to i32, !dbg !1077
  %649 = and i32 %648, -2147483648, !dbg !1077
  %650 = icmp eq i32 %649, 0, !dbg !1077
  %651 = icmp ne i32 %649, 0, !dbg !1077
  %is_pos_inf132 = and i1 %is_inf130, %650, !dbg !1077
  %is_neg_inf133 = and i1 %is_inf130, %651, !dbg !1077
  %is_pos_max134 = and i1 %is_maxfinite131, %650, !dbg !1077
  %is_neg_max135 = and i1 %is_maxfinite131, %651, !dbg !1077
  %overflow_cond136 = and i1 %640, %is_inf130, !dbg !1077
  br i1 %overflow_cond136, label %652, label %654, !dbg !1077

652:                                              ; preds = %636
  %653 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %654, !dbg !1077

654:                                              ; preds = %636, %652
  %655 = bitcast float %579 to i32, !dbg !1077
  %656 = and i32 %655, 2139095040, !dbg !1077
  %657 = icmp eq i32 %656, 0, !dbg !1077
  %658 = and i32 %655, 8388607, !dbg !1077
  %659 = icmp ne i32 %658, 0, !dbg !1077
  %is_subnormal137 = and i1 %657, %659, !dbg !1077
  %660 = xor i1 %is_subnormal137, true, !dbg !1077
  %661 = and i1 true, %660, !dbg !1077
  %662 = bitcast float %637 to i32, !dbg !1077
  %663 = and i32 %662, 2139095040, !dbg !1077
  %664 = icmp eq i32 %663, 0, !dbg !1077
  %665 = and i32 %662, 8388607, !dbg !1077
  %666 = icmp ne i32 %665, 0, !dbg !1077
  %is_subnormal138 = and i1 %664, %666, !dbg !1077
  %subnormal_cond139 = and i1 %661, %is_subnormal138, !dbg !1077
  br i1 %subnormal_cond139, label %667, label %669, !dbg !1077

667:                                              ; preds = %654
  %668 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %669, !dbg !1077

669:                                              ; preds = %654, %667
  %670 = bitcast float %384 to i32, !dbg !1077
  %671 = bitcast float %384 to i32, !dbg !1077
  %672 = and i32 %671, 2139095040, !dbg !1077
  %673 = icmp eq i32 %672, 2139095040, !dbg !1077
  %674 = and i32 %671, 8388607, !dbg !1077
  %675 = icmp ne i32 %674, 0, !dbg !1077
  %is_nan140 = and i1 %673, %675, !dbg !1077
  %676 = and i32 %670, 4194304, !dbg !1077
  %677 = icmp eq i32 %676, 0, !dbg !1077
  %is_snan141 = and i1 %is_nan140, %677, !dbg !1077
  %678 = or i1 %is_snan141, false, !dbg !1077
  %679 = bitcast float %637 to i32, !dbg !1077
  %680 = bitcast float %637 to i32, !dbg !1077
  %681 = and i32 %680, 2139095040, !dbg !1077
  %682 = icmp eq i32 %681, 2139095040, !dbg !1077
  %683 = and i32 %680, 8388607, !dbg !1077
  %684 = icmp ne i32 %683, 0, !dbg !1077
  %is_nan142 = and i1 %682, %684, !dbg !1077
  %685 = and i32 %679, 4194304, !dbg !1077
  %686 = icmp eq i32 %685, 0, !dbg !1077
  %is_snan143 = and i1 %is_nan142, %686, !dbg !1077
  %687 = or i1 %678, %is_snan143, !dbg !1077
  %688 = bitcast float %384 to i32, !dbg !1077
  %689 = and i32 %688, 2147483647, !dbg !1077
  %is_zero144 = icmp eq i32 %689, 0, !dbg !1077
  %690 = and i1 %is_zero144, false, !dbg !1077
  %691 = bitcast float %384 to i32, !dbg !1077
  %692 = and i32 %691, 2139095040, !dbg !1077
  %693 = icmp eq i32 %692, 2139095040, !dbg !1077
  %694 = and i32 %691, 8388607, !dbg !1077
  %695 = icmp eq i32 %694, 0, !dbg !1077
  %is_inf145 = and i1 %693, %695, !dbg !1077
  %696 = and i1 %is_inf145, false, !dbg !1077
  %697 = or i1 %690, %696, !dbg !1077
  %698 = or i1 %687, %697, !dbg !1077
  br i1 %698, label %699, label %701, !dbg !1077

699:                                              ; preds = %669
  %700 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %701, !dbg !1077

701:                                              ; preds = %669, %699
  %702 = call float @llvm.nvvm.fma.rn.f(float %384, float 0x3FF7154760000000, float %637) #5, !dbg !1077
  %703 = bitcast float %384 to i32, !dbg !1077
  %704 = and i32 %703, 2139095040, !dbg !1077
  %is_finite146 = icmp ne i32 %704, 2139095040, !dbg !1077
  %705 = and i1 true, %is_finite146, !dbg !1077
  %706 = and i1 %705, true, !dbg !1077
  %707 = bitcast float %702 to i32, !dbg !1077
  %708 = and i32 %707, 2139095040, !dbg !1077
  %709 = icmp eq i32 %708, 2139095040, !dbg !1077
  %710 = and i32 %707, 8388607, !dbg !1077
  %711 = icmp eq i32 %710, 0, !dbg !1077
  %is_inf147 = and i1 %709, %711, !dbg !1077
  %712 = bitcast float %702 to i32, !dbg !1077
  %713 = and i32 %712, 2147483647, !dbg !1077
  %is_maxfinite148 = icmp eq i32 %713, 2139095039, !dbg !1077
  %714 = bitcast float %702 to i32, !dbg !1077
  %715 = and i32 %714, -2147483648, !dbg !1077
  %716 = icmp eq i32 %715, 0, !dbg !1077
  %717 = icmp ne i32 %715, 0, !dbg !1077
  %is_pos_inf149 = and i1 %is_inf147, %716, !dbg !1077
  %is_neg_inf150 = and i1 %is_inf147, %717, !dbg !1077
  %is_pos_max151 = and i1 %is_maxfinite148, %716, !dbg !1077
  %is_neg_max152 = and i1 %is_maxfinite148, %717, !dbg !1077
  %overflow_cond153 = and i1 %706, %is_inf147, !dbg !1077
  br i1 %overflow_cond153, label %718, label %720, !dbg !1077

718:                                              ; preds = %701
  %719 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %720, !dbg !1077

720:                                              ; preds = %701, %718
  %721 = bitcast float %384 to i32, !dbg !1077
  %722 = and i32 %721, 2139095040, !dbg !1077
  %723 = icmp eq i32 %722, 0, !dbg !1077
  %724 = and i32 %721, 8388607, !dbg !1077
  %725 = icmp ne i32 %724, 0, !dbg !1077
  %is_subnormal154 = and i1 %723, %725, !dbg !1077
  %726 = xor i1 %is_subnormal154, true, !dbg !1077
  %727 = and i1 true, %726, !dbg !1077
  %728 = and i1 %727, true, !dbg !1077
  %729 = bitcast float %637 to i32, !dbg !1077
  %730 = and i32 %729, 2139095040, !dbg !1077
  %731 = icmp eq i32 %730, 0, !dbg !1077
  %732 = and i32 %729, 8388607, !dbg !1077
  %733 = icmp ne i32 %732, 0, !dbg !1077
  %is_subnormal155 = and i1 %731, %733, !dbg !1077
  %734 = xor i1 %is_subnormal155, true, !dbg !1077
  %735 = and i1 %728, %734, !dbg !1077
  %736 = bitcast float %702 to i32, !dbg !1077
  %737 = and i32 %736, 2139095040, !dbg !1077
  %738 = icmp eq i32 %737, 0, !dbg !1077
  %739 = and i32 %736, 8388607, !dbg !1077
  %740 = icmp ne i32 %739, 0, !dbg !1077
  %is_subnormal156 = and i1 %738, %740, !dbg !1077
  %741 = bitcast float %702 to i32, !dbg !1077
  %742 = and i32 %741, 2147483647, !dbg !1077
  %is_zero157 = icmp eq i32 %742, 0, !dbg !1077
  %743 = bitcast float %384 to i32, !dbg !1077
  %744 = and i32 %743, 2147483647, !dbg !1077
  %is_zero158 = icmp eq i32 %744, 0, !dbg !1077
  %745 = xor i1 %is_zero158, true, !dbg !1077
  %746 = bitcast float %637 to i32, !dbg !1077
  %747 = and i32 %746, 2147483647, !dbg !1077
  %is_zero159 = icmp eq i32 %747, 0, !dbg !1077
  %748 = xor i1 %is_zero159, true, !dbg !1077
  %749 = and i1 %745, true, !dbg !1077
  %750 = and i1 %749, %748, !dbg !1077
  %751 = and i1 %is_zero157, %750, !dbg !1077
  %is_tiny160 = or i1 %is_subnormal156, %751, !dbg !1077
  %underflow_cond161 = and i1 %735, %is_tiny160, !dbg !1077
  br i1 %underflow_cond161, label %752, label %754, !dbg !1077

752:                                              ; preds = %720
  %753 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1077
  br label %754, !dbg !1077

754:                                              ; preds = %720, %752
  %755 = bitcast float %384 to i32, !dbg !1077
  %756 = and i32 %755, 2139095040, !dbg !1077
  %757 = icmp eq i32 %756, 0, !dbg !1077
  %758 = and i32 %755, 8388607, !dbg !1077
  %759 = icmp ne i32 %758, 0, !dbg !1077
  %is_subnormal162 = and i1 %757, %759, !dbg !1077
  %760 = xor i1 %is_subnormal162, true, !dbg !1077
  %761 = and i1 true, %760, !dbg !1077
  %762 = and i1 %761, true, !dbg !1077
  %763 = bitcast float %637 to i32, !dbg !1077
  %764 = and i32 %763, 2139095040, !dbg !1077
  %765 = icmp eq i32 %764, 0, !dbg !1077
  %766 = and i32 %763, 8388607, !dbg !1077
  %767 = icmp ne i32 %766, 0, !dbg !1077
  %is_subnormal163 = and i1 %765, %767, !dbg !1077
  %768 = xor i1 %is_subnormal163, true, !dbg !1077
  %769 = and i1 %762, %768, !dbg !1077
  %770 = bitcast float %702 to i32, !dbg !1077
  %771 = and i32 %770, 2139095040, !dbg !1077
  %772 = icmp eq i32 %771, 0, !dbg !1077
  %773 = and i32 %770, 8388607, !dbg !1077
  %774 = icmp ne i32 %773, 0, !dbg !1077
  %is_subnormal164 = and i1 %772, %774, !dbg !1077
  %subnormal_cond165 = and i1 %769, %is_subnormal164, !dbg !1077
  br i1 %subnormal_cond165, label %775, label %777, !dbg !1077

775:                                              ; preds = %754
  %776 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %777, !dbg !1077

777:                                              ; preds = %754, %775
  %778 = bitcast float %384 to i32, !dbg !1077
  %779 = bitcast float %384 to i32, !dbg !1077
  %780 = and i32 %779, 2139095040, !dbg !1077
  %781 = icmp eq i32 %780, 2139095040, !dbg !1077
  %782 = and i32 %779, 8388607, !dbg !1077
  %783 = icmp ne i32 %782, 0, !dbg !1077
  %is_nan166 = and i1 %781, %783, !dbg !1077
  %784 = and i32 %778, 4194304, !dbg !1077
  %785 = icmp eq i32 %784, 0, !dbg !1077
  %is_snan167 = and i1 %is_nan166, %785, !dbg !1077
  %786 = or i1 %is_snan167, false, !dbg !1077
  %787 = bitcast float %702 to i32, !dbg !1077
  %788 = bitcast float %702 to i32, !dbg !1077
  %789 = and i32 %788, 2139095040, !dbg !1077
  %790 = icmp eq i32 %789, 2139095040, !dbg !1077
  %791 = and i32 %788, 8388607, !dbg !1077
  %792 = icmp ne i32 %791, 0, !dbg !1077
  %is_nan168 = and i1 %790, %792, !dbg !1077
  %793 = and i32 %787, 4194304, !dbg !1077
  %794 = icmp eq i32 %793, 0, !dbg !1077
  %is_snan169 = and i1 %is_nan168, %794, !dbg !1077
  %795 = or i1 %786, %is_snan169, !dbg !1077
  %796 = bitcast float %384 to i32, !dbg !1077
  %797 = and i32 %796, 2147483647, !dbg !1077
  %is_zero170 = icmp eq i32 %797, 0, !dbg !1077
  %798 = and i1 %is_zero170, false, !dbg !1077
  %799 = bitcast float %384 to i32, !dbg !1077
  %800 = and i32 %799, 2139095040, !dbg !1077
  %801 = icmp eq i32 %800, 2139095040, !dbg !1077
  %802 = and i32 %799, 8388607, !dbg !1077
  %803 = icmp eq i32 %802, 0, !dbg !1077
  %is_inf171 = and i1 %801, %803, !dbg !1077
  %804 = and i1 %is_inf171, false, !dbg !1077
  %805 = or i1 %798, %804, !dbg !1077
  %806 = or i1 %795, %805, !dbg !1077
  br i1 %806, label %807, label %809, !dbg !1077

807:                                              ; preds = %777
  %808 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %809, !dbg !1077

809:                                              ; preds = %777, %807
  %810 = call float @llvm.nvvm.fma.rn.f(float %384, float 0x3E54AE0C00000000, float %702) #5, !dbg !1077
  %811 = bitcast float %384 to i32, !dbg !1077
  %812 = and i32 %811, 2139095040, !dbg !1077
  %is_finite172 = icmp ne i32 %812, 2139095040, !dbg !1077
  %813 = and i1 true, %is_finite172, !dbg !1077
  %814 = and i1 %813, true, !dbg !1077
  %815 = bitcast float %810 to i32, !dbg !1077
  %816 = and i32 %815, 2139095040, !dbg !1077
  %817 = icmp eq i32 %816, 2139095040, !dbg !1077
  %818 = and i32 %815, 8388607, !dbg !1077
  %819 = icmp eq i32 %818, 0, !dbg !1077
  %is_inf173 = and i1 %817, %819, !dbg !1077
  %820 = bitcast float %810 to i32, !dbg !1077
  %821 = and i32 %820, 2147483647, !dbg !1077
  %is_maxfinite174 = icmp eq i32 %821, 2139095039, !dbg !1077
  %822 = bitcast float %810 to i32, !dbg !1077
  %823 = and i32 %822, -2147483648, !dbg !1077
  %824 = icmp eq i32 %823, 0, !dbg !1077
  %825 = icmp ne i32 %823, 0, !dbg !1077
  %is_pos_inf175 = and i1 %is_inf173, %824, !dbg !1077
  %is_neg_inf176 = and i1 %is_inf173, %825, !dbg !1077
  %is_pos_max177 = and i1 %is_maxfinite174, %824, !dbg !1077
  %is_neg_max178 = and i1 %is_maxfinite174, %825, !dbg !1077
  %overflow_cond179 = and i1 %814, %is_inf173, !dbg !1077
  br i1 %overflow_cond179, label %826, label %828, !dbg !1077

826:                                              ; preds = %809
  %827 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1077
  br label %828, !dbg !1077

828:                                              ; preds = %809, %826
  %829 = bitcast float %384 to i32, !dbg !1077
  %830 = and i32 %829, 2139095040, !dbg !1077
  %831 = icmp eq i32 %830, 0, !dbg !1077
  %832 = and i32 %829, 8388607, !dbg !1077
  %833 = icmp ne i32 %832, 0, !dbg !1077
  %is_subnormal180 = and i1 %831, %833, !dbg !1077
  %834 = xor i1 %is_subnormal180, true, !dbg !1077
  %835 = and i1 true, %834, !dbg !1077
  %836 = and i1 %835, true, !dbg !1077
  %837 = bitcast float %702 to i32, !dbg !1077
  %838 = and i32 %837, 2139095040, !dbg !1077
  %839 = icmp eq i32 %838, 0, !dbg !1077
  %840 = and i32 %837, 8388607, !dbg !1077
  %841 = icmp ne i32 %840, 0, !dbg !1077
  %is_subnormal181 = and i1 %839, %841, !dbg !1077
  %842 = xor i1 %is_subnormal181, true, !dbg !1077
  %843 = and i1 %836, %842, !dbg !1077
  %844 = bitcast float %810 to i32, !dbg !1077
  %845 = and i32 %844, 2139095040, !dbg !1077
  %846 = icmp eq i32 %845, 0, !dbg !1077
  %847 = and i32 %844, 8388607, !dbg !1077
  %848 = icmp ne i32 %847, 0, !dbg !1077
  %is_subnormal182 = and i1 %846, %848, !dbg !1077
  %849 = bitcast float %810 to i32, !dbg !1077
  %850 = and i32 %849, 2147483647, !dbg !1077
  %is_zero183 = icmp eq i32 %850, 0, !dbg !1077
  %851 = bitcast float %384 to i32, !dbg !1077
  %852 = and i32 %851, 2147483647, !dbg !1077
  %is_zero184 = icmp eq i32 %852, 0, !dbg !1077
  %853 = xor i1 %is_zero184, true, !dbg !1077
  %854 = bitcast float %702 to i32, !dbg !1077
  %855 = and i32 %854, 2147483647, !dbg !1077
  %is_zero185 = icmp eq i32 %855, 0, !dbg !1077
  %856 = xor i1 %is_zero185, true, !dbg !1077
  %857 = and i1 %853, true, !dbg !1077
  %858 = and i1 %857, %856, !dbg !1077
  %859 = and i1 %is_zero183, %858, !dbg !1077
  %is_tiny186 = or i1 %is_subnormal182, %859, !dbg !1077
  %underflow_cond187 = and i1 %843, %is_tiny186, !dbg !1077
  br i1 %underflow_cond187, label %860, label %862, !dbg !1077

860:                                              ; preds = %828
  %861 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1077
  br label %862, !dbg !1077

862:                                              ; preds = %828, %860
  %863 = bitcast float %384 to i32, !dbg !1077
  %864 = and i32 %863, 2139095040, !dbg !1077
  %865 = icmp eq i32 %864, 0, !dbg !1077
  %866 = and i32 %863, 8388607, !dbg !1077
  %867 = icmp ne i32 %866, 0, !dbg !1077
  %is_subnormal188 = and i1 %865, %867, !dbg !1077
  %868 = xor i1 %is_subnormal188, true, !dbg !1077
  %869 = and i1 true, %868, !dbg !1077
  %870 = and i1 %869, true, !dbg !1077
  %871 = bitcast float %702 to i32, !dbg !1077
  %872 = and i32 %871, 2139095040, !dbg !1077
  %873 = icmp eq i32 %872, 0, !dbg !1077
  %874 = and i32 %871, 8388607, !dbg !1077
  %875 = icmp ne i32 %874, 0, !dbg !1077
  %is_subnormal189 = and i1 %873, %875, !dbg !1077
  %876 = xor i1 %is_subnormal189, true, !dbg !1077
  %877 = and i1 %870, %876, !dbg !1077
  %878 = bitcast float %810 to i32, !dbg !1077
  %879 = and i32 %878, 2139095040, !dbg !1077
  %880 = icmp eq i32 %879, 0, !dbg !1077
  %881 = and i32 %878, 8388607, !dbg !1077
  %882 = icmp ne i32 %881, 0, !dbg !1077
  %is_subnormal190 = and i1 %880, %882, !dbg !1077
  %subnormal_cond191 = and i1 %877, %is_subnormal190, !dbg !1077
  br i1 %subnormal_cond191, label %883, label %885, !dbg !1077

883:                                              ; preds = %862
  %884 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1077
  br label %885, !dbg !1077

885:                                              ; preds = %862, %883
  %886 = bitcast float %495 to i32, !dbg !1077
  %887 = shl i32 %886, 23, !dbg !1077
  %888 = bitcast i32 %887 to float, !dbg !1077
  %889 = call float @llvm.nvvm.ex2.approx.ftz.f32(float %810), !dbg !1077
  %890 = bitcast float %889 to i32, !dbg !1077
  %891 = bitcast float %889 to i32, !dbg !1077
  %892 = and i32 %891, 2139095040, !dbg !1077
  %893 = icmp eq i32 %892, 2139095040, !dbg !1077
  %894 = and i32 %891, 8388607, !dbg !1077
  %895 = icmp ne i32 %894, 0, !dbg !1077
  %is_nan192 = and i1 %893, %895, !dbg !1077
  %896 = and i32 %890, 4194304, !dbg !1077
  %897 = icmp eq i32 %896, 0, !dbg !1077
  %is_snan193 = and i1 %is_nan192, %897, !dbg !1077
  %898 = bitcast float %888 to i32, !dbg !1077
  %899 = bitcast float %888 to i32, !dbg !1077
  %900 = and i32 %899, 2139095040, !dbg !1077
  %901 = icmp eq i32 %900, 2139095040, !dbg !1077
  %902 = and i32 %899, 8388607, !dbg !1077
  %903 = icmp ne i32 %902, 0, !dbg !1077
  %is_nan194 = and i1 %901, %903, !dbg !1077
  %904 = and i32 %898, 4194304, !dbg !1077
  %905 = icmp eq i32 %904, 0, !dbg !1077
  %is_snan195 = and i1 %is_nan194, %905, !dbg !1077
  %906 = or i1 %is_snan193, %is_snan195, !dbg !1077
  %907 = bitcast float %889 to i32, !dbg !1077
  %908 = and i32 %907, 2147483647, !dbg !1077
  %is_zero196 = icmp eq i32 %908, 0, !dbg !1077
  %909 = bitcast float %888 to i32, !dbg !1077
  %910 = and i32 %909, 2139095040, !dbg !1077
  %911 = icmp eq i32 %910, 2139095040, !dbg !1077
  %912 = and i32 %909, 8388607, !dbg !1077
  %913 = icmp eq i32 %912, 0, !dbg !1077
  %is_inf197 = and i1 %911, %913, !dbg !1077
  %914 = and i1 %is_zero196, %is_inf197, !dbg !1077
  %915 = bitcast float %889 to i32, !dbg !1077
  %916 = and i32 %915, 2139095040, !dbg !1077
  %917 = icmp eq i32 %916, 2139095040, !dbg !1077
  %918 = and i32 %915, 8388607, !dbg !1077
  %919 = icmp eq i32 %918, 0, !dbg !1077
  %is_inf198 = and i1 %917, %919, !dbg !1077
  %920 = bitcast float %888 to i32, !dbg !1077
  %921 = and i32 %920, 2147483647, !dbg !1077
  %is_zero199 = icmp eq i32 %921, 0, !dbg !1077
  %922 = and i1 %is_inf198, %is_zero199, !dbg !1077
  %923 = or i1 %914, %922, !dbg !1077
  %924 = or i1 %906, %923, !dbg !1077
  br i1 %924, label %925, label %927, !dbg !1077

925:                                              ; preds = %885
  %926 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1077
  br label %927, !dbg !1077

927:                                              ; preds = %885, %925
  %928 = fmul float %889, %888, !dbg !1077
  %929 = bitcast float %889 to i32, !dbg !1078
  %930 = and i32 %929, 2139095040, !dbg !1078
  %is_finite200 = icmp ne i32 %930, 2139095040, !dbg !1078
  %931 = and i1 true, %is_finite200, !dbg !1078
  %932 = bitcast float %888 to i32, !dbg !1078
  %933 = and i32 %932, 2139095040, !dbg !1078
  %is_finite201 = icmp ne i32 %933, 2139095040, !dbg !1078
  %934 = and i1 %931, %is_finite201, !dbg !1078
  %935 = bitcast float %928 to i32, !dbg !1078
  %936 = and i32 %935, 2139095040, !dbg !1078
  %937 = icmp eq i32 %936, 2139095040, !dbg !1078
  %938 = and i32 %935, 8388607, !dbg !1078
  %939 = icmp eq i32 %938, 0, !dbg !1078
  %is_inf202 = and i1 %937, %939, !dbg !1078
  %940 = bitcast float %928 to i32, !dbg !1078
  %941 = and i32 %940, 2147483647, !dbg !1078
  %is_maxfinite203 = icmp eq i32 %941, 2139095039, !dbg !1078
  %942 = bitcast float %928 to i32, !dbg !1078
  %943 = and i32 %942, -2147483648, !dbg !1078
  %944 = icmp eq i32 %943, 0, !dbg !1078
  %945 = icmp ne i32 %943, 0, !dbg !1078
  %is_pos_inf204 = and i1 %is_inf202, %944, !dbg !1078
  %is_neg_inf205 = and i1 %is_inf202, %945, !dbg !1078
  %is_pos_max206 = and i1 %is_maxfinite203, %944, !dbg !1078
  %is_neg_max207 = and i1 %is_maxfinite203, %945, !dbg !1078
  %overflow_cond208 = and i1 %934, %is_inf202, !dbg !1078
  br i1 %overflow_cond208, label %946, label %948, !dbg !1078

946:                                              ; preds = %927
  %947 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1078
  br label %948, !dbg !1078

948:                                              ; preds = %927, %946
  %949 = bitcast float %889 to i32, !dbg !1078
  %950 = and i32 %949, 2139095040, !dbg !1078
  %951 = icmp eq i32 %950, 0, !dbg !1078
  %952 = and i32 %949, 8388607, !dbg !1078
  %953 = icmp ne i32 %952, 0, !dbg !1078
  %is_subnormal209 = and i1 %951, %953, !dbg !1078
  %954 = xor i1 %is_subnormal209, true, !dbg !1078
  %955 = and i1 true, %954, !dbg !1078
  %956 = bitcast float %888 to i32, !dbg !1078
  %957 = and i32 %956, 2139095040, !dbg !1078
  %958 = icmp eq i32 %957, 0, !dbg !1078
  %959 = and i32 %956, 8388607, !dbg !1078
  %960 = icmp ne i32 %959, 0, !dbg !1078
  %is_subnormal210 = and i1 %958, %960, !dbg !1078
  %961 = xor i1 %is_subnormal210, true, !dbg !1078
  %962 = and i1 %955, %961, !dbg !1078
  %963 = bitcast float %928 to i32, !dbg !1078
  %964 = and i32 %963, 2139095040, !dbg !1078
  %965 = icmp eq i32 %964, 0, !dbg !1078
  %966 = and i32 %963, 8388607, !dbg !1078
  %967 = icmp ne i32 %966, 0, !dbg !1078
  %is_subnormal211 = and i1 %965, %967, !dbg !1078
  %968 = bitcast float %928 to i32, !dbg !1078
  %969 = and i32 %968, 2147483647, !dbg !1078
  %is_zero212 = icmp eq i32 %969, 0, !dbg !1078
  %970 = bitcast float %889 to i32, !dbg !1078
  %971 = and i32 %970, 2147483647, !dbg !1078
  %is_zero213 = icmp eq i32 %971, 0, !dbg !1078
  %972 = xor i1 %is_zero213, true, !dbg !1078
  %973 = bitcast float %888 to i32, !dbg !1078
  %974 = and i32 %973, 2147483647, !dbg !1078
  %is_zero214 = icmp eq i32 %974, 0, !dbg !1078
  %975 = xor i1 %is_zero214, true, !dbg !1078
  %976 = and i1 %972, %975, !dbg !1078
  %977 = and i1 %is_zero212, %976, !dbg !1078
  %is_tiny215 = or i1 %is_subnormal211, %977, !dbg !1078
  %underflow_cond216 = and i1 %962, %is_tiny215, !dbg !1078
  br i1 %underflow_cond216, label %978, label %980, !dbg !1078

978:                                              ; preds = %948
  %979 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1078
  br label %980, !dbg !1078

980:                                              ; preds = %948, %978
  %981 = bitcast float %889 to i32, !dbg !1078
  %982 = and i32 %981, 2139095040, !dbg !1078
  %983 = icmp eq i32 %982, 0, !dbg !1078
  %984 = and i32 %981, 8388607, !dbg !1078
  %985 = icmp ne i32 %984, 0, !dbg !1078
  %is_subnormal217 = and i1 %983, %985, !dbg !1078
  %986 = xor i1 %is_subnormal217, true, !dbg !1078
  %987 = and i1 true, %986, !dbg !1078
  %988 = bitcast float %888 to i32, !dbg !1078
  %989 = and i32 %988, 2139095040, !dbg !1078
  %990 = icmp eq i32 %989, 0, !dbg !1078
  %991 = and i32 %988, 8388607, !dbg !1078
  %992 = icmp ne i32 %991, 0, !dbg !1078
  %is_subnormal218 = and i1 %990, %992, !dbg !1078
  %993 = xor i1 %is_subnormal218, true, !dbg !1078
  %994 = and i1 %987, %993, !dbg !1078
  %995 = bitcast float %928 to i32, !dbg !1078
  %996 = and i32 %995, 2139095040, !dbg !1078
  %997 = icmp eq i32 %996, 0, !dbg !1078
  %998 = and i32 %995, 8388607, !dbg !1078
  %999 = icmp ne i32 %998, 0, !dbg !1078
  %is_subnormal219 = and i1 %997, %999, !dbg !1078
  %subnormal_cond220 = and i1 %994, %is_subnormal219, !dbg !1078
  br i1 %subnormal_cond220, label %1000, label %1002, !dbg !1078

1000:                                             ; preds = %980
  %1001 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1078
  br label %1002, !dbg !1078

1002:                                             ; preds = %980, %1000
  %1003 = load ptr, ptr %result.addr, align 8, !dbg !1078
  %arrayidx40 = getelementptr inbounds float, ptr %1003, i64 5, !dbg !1078
  store float %928, ptr %arrayidx40, align 4, !dbg !1079
  %1004 = load ptr, ptr %result.addr, align 8, !dbg !1080
  %arrayidx41 = getelementptr inbounds float, ptr %1004, i64 5, !dbg !1080
  %1005 = load float, ptr %arrayidx41, align 4, !dbg !1080
  %call42 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %1005) #4, !dbg !1081
  %1006 = zext i1 %call42 to i64, !dbg !1081
  %cond43 = select i1 %call42, i32 1, i32 0, !dbg !1081
  %1007 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1082
  %arrayidx44 = getelementptr inbounds i32, ptr %1007, i64 5, !dbg !1082
  store i32 %cond43, ptr %arrayidx44, align 4, !dbg !1083
  br label %if.end45, !dbg !1084

if.end45:                                         ; preds = %1002, %if.end36
  %1008 = load i32, ptr %idx, align 4, !dbg !1085
  %cmp46 = icmp eq i32 %1008, 6, !dbg !1087
  br i1 %cmp46, label %if.then47, label %if.end54, !dbg !1087

if.then47:                                        ; preds = %if.end45
  store float 0x3FB99999A0000000, ptr %__a.addr.i66, align 4
    #dbg_declare(ptr %__a.addr.i66, !1088, !DIExpression(), !1089)
  store float 4.000000e+01, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1092, !DIExpression(), !1093)
  %1009 = load float, ptr %__a.addr.i66, align 4, !dbg !1094
  %1010 = load float, ptr %__b.addr.i, align 4, !dbg !1095
  %1011 = bitcast float %1010 to i32, !dbg !1096
  %1012 = bitcast float %1010 to i32, !dbg !1096
  %1013 = and i32 %1012, 2139095040, !dbg !1096
  %1014 = icmp eq i32 %1013, 2139095040, !dbg !1096
  %1015 = and i32 %1012, 8388607, !dbg !1096
  %1016 = icmp ne i32 %1015, 0, !dbg !1096
  %is_nan221 = and i1 %1014, %1016, !dbg !1096
  %1017 = and i32 %1011, 4194304, !dbg !1096
  %1018 = icmp eq i32 %1017, 0, !dbg !1096
  %is_snan222 = and i1 %is_nan221, %1018, !dbg !1096
  %1019 = or i1 false, %is_snan222, !dbg !1096
  %1020 = bitcast float %1010 to i32, !dbg !1096
  %1021 = and i32 %1020, 2139095040, !dbg !1096
  %1022 = icmp eq i32 %1021, 2139095040, !dbg !1096
  %1023 = and i32 %1020, 8388607, !dbg !1096
  %1024 = icmp eq i32 %1023, 0, !dbg !1096
  %is_inf223 = and i1 %1022, %1024, !dbg !1096
  %1025 = and i1 false, %is_inf223, !dbg !1096
  %1026 = bitcast float %1010 to i32, !dbg !1096
  %1027 = and i32 %1026, 2147483647, !dbg !1096
  %is_zero224 = icmp eq i32 %1027, 0, !dbg !1096
  %1028 = and i1 false, %is_zero224, !dbg !1096
  %1029 = or i1 %1025, %1028, !dbg !1096
  %1030 = or i1 %1019, %1029, !dbg !1096
  br i1 %1030, label %1031, label %1033, !dbg !1096

1031:                                             ; preds = %if.then47
  %1032 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1033, !dbg !1096

1033:                                             ; preds = %if.then47, %1031
  %1034 = fmul float 5.000000e-01, %1010, !dbg !1096
  %1035 = bitcast float %1010 to i32, !dbg !1096
  %1036 = and i32 %1035, 2139095040, !dbg !1096
  %is_finite225 = icmp ne i32 %1036, 2139095040, !dbg !1096
  %1037 = and i1 true, %is_finite225, !dbg !1096
  %1038 = bitcast float %1034 to i32, !dbg !1096
  %1039 = and i32 %1038, 2139095040, !dbg !1096
  %1040 = icmp eq i32 %1039, 2139095040, !dbg !1096
  %1041 = and i32 %1038, 8388607, !dbg !1096
  %1042 = icmp eq i32 %1041, 0, !dbg !1096
  %is_inf226 = and i1 %1040, %1042, !dbg !1096
  %1043 = bitcast float %1034 to i32, !dbg !1096
  %1044 = and i32 %1043, 2147483647, !dbg !1096
  %is_maxfinite227 = icmp eq i32 %1044, 2139095039, !dbg !1096
  %1045 = bitcast float %1034 to i32, !dbg !1096
  %1046 = and i32 %1045, -2147483648, !dbg !1096
  %1047 = icmp eq i32 %1046, 0, !dbg !1096
  %1048 = icmp ne i32 %1046, 0, !dbg !1096
  %is_pos_inf228 = and i1 %is_inf226, %1047, !dbg !1096
  %is_neg_inf229 = and i1 %is_inf226, %1048, !dbg !1096
  %is_pos_max230 = and i1 %is_maxfinite227, %1047, !dbg !1096
  %is_neg_max231 = and i1 %is_maxfinite227, %1048, !dbg !1096
  %overflow_cond232 = and i1 %1037, %is_inf226, !dbg !1096
  br i1 %overflow_cond232, label %1049, label %1051, !dbg !1096

1049:                                             ; preds = %1033
  %1050 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1051, !dbg !1096

1051:                                             ; preds = %1033, %1049
  %1052 = bitcast float %1010 to i32, !dbg !1096
  %1053 = and i32 %1052, 2139095040, !dbg !1096
  %1054 = icmp eq i32 %1053, 0, !dbg !1096
  %1055 = and i32 %1052, 8388607, !dbg !1096
  %1056 = icmp ne i32 %1055, 0, !dbg !1096
  %is_subnormal233 = and i1 %1054, %1056, !dbg !1096
  %1057 = xor i1 %is_subnormal233, true, !dbg !1096
  %1058 = and i1 true, %1057, !dbg !1096
  %1059 = bitcast float %1034 to i32, !dbg !1096
  %1060 = and i32 %1059, 2139095040, !dbg !1096
  %1061 = icmp eq i32 %1060, 0, !dbg !1096
  %1062 = and i32 %1059, 8388607, !dbg !1096
  %1063 = icmp ne i32 %1062, 0, !dbg !1096
  %is_subnormal234 = and i1 %1061, %1063, !dbg !1096
  %1064 = bitcast float %1034 to i32, !dbg !1096
  %1065 = and i32 %1064, 2147483647, !dbg !1096
  %is_zero235 = icmp eq i32 %1065, 0, !dbg !1096
  %1066 = bitcast float %1010 to i32, !dbg !1096
  %1067 = and i32 %1066, 2147483647, !dbg !1096
  %is_zero236 = icmp eq i32 %1067, 0, !dbg !1096
  %1068 = xor i1 %is_zero236, true, !dbg !1096
  %1069 = and i1 true, %1068, !dbg !1096
  %1070 = and i1 %is_zero235, %1069, !dbg !1096
  %is_tiny237 = or i1 %is_subnormal234, %1070, !dbg !1096
  %underflow_cond238 = and i1 %1058, %is_tiny237, !dbg !1096
  br i1 %underflow_cond238, label %1071, label %1073, !dbg !1096

1071:                                             ; preds = %1051
  %1072 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1073, !dbg !1096

1073:                                             ; preds = %1051, %1071
  %1074 = bitcast float %1010 to i32, !dbg !1096
  %1075 = and i32 %1074, 2139095040, !dbg !1096
  %1076 = icmp eq i32 %1075, 0, !dbg !1096
  %1077 = and i32 %1074, 8388607, !dbg !1096
  %1078 = icmp ne i32 %1077, 0, !dbg !1096
  %is_subnormal239 = and i1 %1076, %1078, !dbg !1096
  %1079 = xor i1 %is_subnormal239, true, !dbg !1096
  %1080 = and i1 true, %1079, !dbg !1096
  %1081 = bitcast float %1034 to i32, !dbg !1096
  %1082 = and i32 %1081, 2139095040, !dbg !1096
  %1083 = icmp eq i32 %1082, 0, !dbg !1096
  %1084 = and i32 %1081, 8388607, !dbg !1096
  %1085 = icmp ne i32 %1084, 0, !dbg !1096
  %is_subnormal240 = and i1 %1083, %1085, !dbg !1096
  %subnormal_cond241 = and i1 %1080, %is_subnormal240, !dbg !1096
  br i1 %subnormal_cond241, label %1086, label %1088, !dbg !1096

1086:                                             ; preds = %1073
  %1087 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1088, !dbg !1096

1088:                                             ; preds = %1073, %1086
  %1089 = call float @llvm.nvvm.trunc.f(float %1034) #5, !dbg !1096
  %1090 = bitcast float %1089 to i32, !dbg !1096
  %1091 = bitcast float %1089 to i32, !dbg !1096
  %1092 = and i32 %1091, 2139095040, !dbg !1096
  %1093 = icmp eq i32 %1092, 2139095040, !dbg !1096
  %1094 = and i32 %1091, 8388607, !dbg !1096
  %1095 = icmp ne i32 %1094, 0, !dbg !1096
  %is_nan242 = and i1 %1093, %1095, !dbg !1096
  %1096 = and i32 %1090, 4194304, !dbg !1096
  %1097 = icmp eq i32 %1096, 0, !dbg !1096
  %is_snan243 = and i1 %is_nan242, %1097, !dbg !1096
  %1098 = or i1 false, %is_snan243, !dbg !1096
  %1099 = bitcast float %1089 to i32, !dbg !1096
  %1100 = and i32 %1099, 2139095040, !dbg !1096
  %1101 = icmp eq i32 %1100, 2139095040, !dbg !1096
  %1102 = and i32 %1099, 8388607, !dbg !1096
  %1103 = icmp eq i32 %1102, 0, !dbg !1096
  %is_inf244 = and i1 %1101, %1103, !dbg !1096
  %1104 = and i1 false, %is_inf244, !dbg !1096
  %1105 = bitcast float %1089 to i32, !dbg !1096
  %1106 = and i32 %1105, 2147483647, !dbg !1096
  %is_zero245 = icmp eq i32 %1106, 0, !dbg !1096
  %1107 = and i1 false, %is_zero245, !dbg !1096
  %1108 = or i1 %1104, %1107, !dbg !1096
  %1109 = or i1 %1098, %1108, !dbg !1096
  br i1 %1109, label %1110, label %1112, !dbg !1096

1110:                                             ; preds = %1088
  %1111 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1112, !dbg !1096

1112:                                             ; preds = %1088, %1110
  %1113 = fmul float 2.000000e+00, %1089, !dbg !1096
  %1114 = bitcast float %1089 to i32, !dbg !1096
  %1115 = and i32 %1114, 2139095040, !dbg !1096
  %is_finite246 = icmp ne i32 %1115, 2139095040, !dbg !1096
  %1116 = and i1 true, %is_finite246, !dbg !1096
  %1117 = bitcast float %1113 to i32, !dbg !1096
  %1118 = and i32 %1117, 2139095040, !dbg !1096
  %1119 = icmp eq i32 %1118, 2139095040, !dbg !1096
  %1120 = and i32 %1117, 8388607, !dbg !1096
  %1121 = icmp eq i32 %1120, 0, !dbg !1096
  %is_inf247 = and i1 %1119, %1121, !dbg !1096
  %1122 = bitcast float %1113 to i32, !dbg !1096
  %1123 = and i32 %1122, 2147483647, !dbg !1096
  %is_maxfinite248 = icmp eq i32 %1123, 2139095039, !dbg !1096
  %1124 = bitcast float %1113 to i32, !dbg !1096
  %1125 = and i32 %1124, -2147483648, !dbg !1096
  %1126 = icmp eq i32 %1125, 0, !dbg !1096
  %1127 = icmp ne i32 %1125, 0, !dbg !1096
  %is_pos_inf249 = and i1 %is_inf247, %1126, !dbg !1096
  %is_neg_inf250 = and i1 %is_inf247, %1127, !dbg !1096
  %is_pos_max251 = and i1 %is_maxfinite248, %1126, !dbg !1096
  %is_neg_max252 = and i1 %is_maxfinite248, %1127, !dbg !1096
  %overflow_cond253 = and i1 %1116, %is_inf247, !dbg !1096
  br i1 %overflow_cond253, label %1128, label %1130, !dbg !1096

1128:                                             ; preds = %1112
  %1129 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1130, !dbg !1096

1130:                                             ; preds = %1112, %1128
  %1131 = bitcast float %1089 to i32, !dbg !1096
  %1132 = and i32 %1131, 2139095040, !dbg !1096
  %1133 = icmp eq i32 %1132, 0, !dbg !1096
  %1134 = and i32 %1131, 8388607, !dbg !1096
  %1135 = icmp ne i32 %1134, 0, !dbg !1096
  %is_subnormal254 = and i1 %1133, %1135, !dbg !1096
  %1136 = xor i1 %is_subnormal254, true, !dbg !1096
  %1137 = and i1 true, %1136, !dbg !1096
  %1138 = bitcast float %1113 to i32, !dbg !1096
  %1139 = and i32 %1138, 2139095040, !dbg !1096
  %1140 = icmp eq i32 %1139, 0, !dbg !1096
  %1141 = and i32 %1138, 8388607, !dbg !1096
  %1142 = icmp ne i32 %1141, 0, !dbg !1096
  %is_subnormal255 = and i1 %1140, %1142, !dbg !1096
  %1143 = bitcast float %1113 to i32, !dbg !1096
  %1144 = and i32 %1143, 2147483647, !dbg !1096
  %is_zero256 = icmp eq i32 %1144, 0, !dbg !1096
  %1145 = bitcast float %1089 to i32, !dbg !1096
  %1146 = and i32 %1145, 2147483647, !dbg !1096
  %is_zero257 = icmp eq i32 %1146, 0, !dbg !1096
  %1147 = xor i1 %is_zero257, true, !dbg !1096
  %1148 = and i1 true, %1147, !dbg !1096
  %1149 = and i1 %is_zero256, %1148, !dbg !1096
  %is_tiny258 = or i1 %is_subnormal255, %1149, !dbg !1096
  %underflow_cond259 = and i1 %1137, %is_tiny258, !dbg !1096
  br i1 %underflow_cond259, label %1150, label %1152, !dbg !1096

1150:                                             ; preds = %1130
  %1151 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1152, !dbg !1096

1152:                                             ; preds = %1130, %1150
  %1153 = bitcast float %1089 to i32, !dbg !1096
  %1154 = and i32 %1153, 2139095040, !dbg !1096
  %1155 = icmp eq i32 %1154, 0, !dbg !1096
  %1156 = and i32 %1153, 8388607, !dbg !1096
  %1157 = icmp ne i32 %1156, 0, !dbg !1096
  %is_subnormal260 = and i1 %1155, %1157, !dbg !1096
  %1158 = xor i1 %is_subnormal260, true, !dbg !1096
  %1159 = and i1 true, %1158, !dbg !1096
  %1160 = bitcast float %1113 to i32, !dbg !1096
  %1161 = and i32 %1160, 2139095040, !dbg !1096
  %1162 = icmp eq i32 %1161, 0, !dbg !1096
  %1163 = and i32 %1160, 8388607, !dbg !1096
  %1164 = icmp ne i32 %1163, 0, !dbg !1096
  %is_subnormal261 = and i1 %1162, %1164, !dbg !1096
  %subnormal_cond262 = and i1 %1159, %is_subnormal261, !dbg !1096
  br i1 %subnormal_cond262, label %1165, label %1167, !dbg !1096

1165:                                             ; preds = %1152
  %1166 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1167, !dbg !1096

1167:                                             ; preds = %1152, %1165
  %1168 = bitcast float %1010 to i32, !dbg !1096
  %1169 = bitcast float %1010 to i32, !dbg !1096
  %1170 = and i32 %1169, 2139095040, !dbg !1096
  %1171 = icmp eq i32 %1170, 2139095040, !dbg !1096
  %1172 = and i32 %1169, 8388607, !dbg !1096
  %1173 = icmp ne i32 %1172, 0, !dbg !1096
  %is_nan263 = and i1 %1171, %1173, !dbg !1096
  %1174 = and i32 %1168, 4194304, !dbg !1096
  %1175 = icmp eq i32 %1174, 0, !dbg !1096
  %is_snan264 = and i1 %is_nan263, %1175, !dbg !1096
  %1176 = bitcast float %1113 to i32, !dbg !1096
  %1177 = bitcast float %1113 to i32, !dbg !1096
  %1178 = and i32 %1177, 2139095040, !dbg !1096
  %1179 = icmp eq i32 %1178, 2139095040, !dbg !1096
  %1180 = and i32 %1177, 8388607, !dbg !1096
  %1181 = icmp ne i32 %1180, 0, !dbg !1096
  %is_nan265 = and i1 %1179, %1181, !dbg !1096
  %1182 = and i32 %1176, 4194304, !dbg !1096
  %1183 = icmp eq i32 %1182, 0, !dbg !1096
  %is_snan266 = and i1 %is_nan265, %1183, !dbg !1096
  %1184 = or i1 %is_snan264, %is_snan266, !dbg !1096
  %1185 = bitcast float %1010 to i32, !dbg !1096
  %1186 = and i32 %1185, 2139095040, !dbg !1096
  %1187 = icmp eq i32 %1186, 2139095040, !dbg !1096
  %1188 = and i32 %1185, 8388607, !dbg !1096
  %1189 = icmp eq i32 %1188, 0, !dbg !1096
  %is_inf267 = and i1 %1187, %1189, !dbg !1096
  %1190 = bitcast float %1113 to i32, !dbg !1096
  %1191 = and i32 %1190, 2139095040, !dbg !1096
  %1192 = icmp eq i32 %1191, 2139095040, !dbg !1096
  %1193 = and i32 %1190, 8388607, !dbg !1096
  %1194 = icmp eq i32 %1193, 0, !dbg !1096
  %is_inf268 = and i1 %1192, %1194, !dbg !1096
  %1195 = and i1 %is_inf267, %is_inf268, !dbg !1096
  %1196 = bitcast float %1010 to i32, !dbg !1096
  %1197 = bitcast float %1113 to i32, !dbg !1096
  %1198 = and i32 %1196, -2147483648, !dbg !1096
  %1199 = and i32 %1197, -2147483648, !dbg !1096
  %1200 = icmp eq i32 %1198, %1199, !dbg !1096
  %1201 = and i1 %1195, %1200, !dbg !1096
  %1202 = or i1 %1184, %1201, !dbg !1096
  br i1 %1202, label %1203, label %1205, !dbg !1096

1203:                                             ; preds = %1167
  %1204 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1205, !dbg !1096

1205:                                             ; preds = %1167, %1203
  %1206 = fsub float %1010, %1113, !dbg !1096
  %1207 = bitcast float %1010 to i32, !dbg !1096
  %1208 = and i32 %1207, 2139095040, !dbg !1096
  %is_finite269 = icmp ne i32 %1208, 2139095040, !dbg !1096
  %1209 = and i1 true, %is_finite269, !dbg !1096
  %1210 = bitcast float %1113 to i32, !dbg !1096
  %1211 = and i32 %1210, 2139095040, !dbg !1096
  %is_finite270 = icmp ne i32 %1211, 2139095040, !dbg !1096
  %1212 = and i1 %1209, %is_finite270, !dbg !1096
  %1213 = bitcast float %1206 to i32, !dbg !1096
  %1214 = and i32 %1213, 2139095040, !dbg !1096
  %1215 = icmp eq i32 %1214, 2139095040, !dbg !1096
  %1216 = and i32 %1213, 8388607, !dbg !1096
  %1217 = icmp eq i32 %1216, 0, !dbg !1096
  %is_inf271 = and i1 %1215, %1217, !dbg !1096
  %1218 = bitcast float %1206 to i32, !dbg !1096
  %1219 = and i32 %1218, 2147483647, !dbg !1096
  %is_maxfinite272 = icmp eq i32 %1219, 2139095039, !dbg !1096
  %1220 = bitcast float %1206 to i32, !dbg !1096
  %1221 = and i32 %1220, -2147483648, !dbg !1096
  %1222 = icmp eq i32 %1221, 0, !dbg !1096
  %1223 = icmp ne i32 %1221, 0, !dbg !1096
  %is_pos_inf273 = and i1 %is_inf271, %1222, !dbg !1096
  %is_neg_inf274 = and i1 %is_inf271, %1223, !dbg !1096
  %is_pos_max275 = and i1 %is_maxfinite272, %1222, !dbg !1096
  %is_neg_max276 = and i1 %is_maxfinite272, %1223, !dbg !1096
  %overflow_cond277 = and i1 %1212, %is_inf271, !dbg !1096
  br i1 %overflow_cond277, label %1224, label %1226, !dbg !1096

1224:                                             ; preds = %1205
  %1225 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1226, !dbg !1096

1226:                                             ; preds = %1205, %1224
  %1227 = bitcast float %1010 to i32, !dbg !1096
  %1228 = and i32 %1227, 2139095040, !dbg !1096
  %1229 = icmp eq i32 %1228, 0, !dbg !1096
  %1230 = and i32 %1227, 8388607, !dbg !1096
  %1231 = icmp ne i32 %1230, 0, !dbg !1096
  %is_subnormal278 = and i1 %1229, %1231, !dbg !1096
  %1232 = xor i1 %is_subnormal278, true, !dbg !1096
  %1233 = and i1 true, %1232, !dbg !1096
  %1234 = bitcast float %1113 to i32, !dbg !1096
  %1235 = and i32 %1234, 2139095040, !dbg !1096
  %1236 = icmp eq i32 %1235, 0, !dbg !1096
  %1237 = and i32 %1234, 8388607, !dbg !1096
  %1238 = icmp ne i32 %1237, 0, !dbg !1096
  %is_subnormal279 = and i1 %1236, %1238, !dbg !1096
  %1239 = xor i1 %is_subnormal279, true, !dbg !1096
  %1240 = and i1 %1233, %1239, !dbg !1096
  %1241 = bitcast float %1206 to i32, !dbg !1096
  %1242 = and i32 %1241, 2139095040, !dbg !1096
  %1243 = icmp eq i32 %1242, 0, !dbg !1096
  %1244 = and i32 %1241, 8388607, !dbg !1096
  %1245 = icmp ne i32 %1244, 0, !dbg !1096
  %is_subnormal280 = and i1 %1243, %1245, !dbg !1096
  %subnormal_cond281 = and i1 %1240, %is_subnormal280, !dbg !1096
  br i1 %subnormal_cond281, label %1246, label %1248, !dbg !1096

1246:                                             ; preds = %1226
  %1247 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1248, !dbg !1096

1248:                                             ; preds = %1226, %1246
  %1249 = call float @llvm.nvvm.fabs.f32(float %1206), !dbg !1096
  %1250 = fcmp oeq float %1249, 1.000000e+00, !dbg !1096
  %1251 = select i1 %1250, i32 1, i32 0, !dbg !1096
  %1252 = call float @llvm.nvvm.fabs.f32(float %1009), !dbg !1096
  %1253 = fcmp olt float %1252, 0x3810000000000000, !dbg !1096
  br i1 %1253, label %1254, label %1336, !dbg !1096

1254:                                             ; preds = %1248
  %1255 = bitcast float %1252 to i32, !dbg !1096
  %1256 = bitcast float %1252 to i32, !dbg !1096
  %1257 = and i32 %1256, 2139095040, !dbg !1096
  %1258 = icmp eq i32 %1257, 2139095040, !dbg !1096
  %1259 = and i32 %1256, 8388607, !dbg !1096
  %1260 = icmp ne i32 %1259, 0, !dbg !1096
  %is_nan282 = and i1 %1258, %1260, !dbg !1096
  %1261 = and i32 %1255, 4194304, !dbg !1096
  %1262 = icmp eq i32 %1261, 0, !dbg !1096
  %is_snan283 = and i1 %is_nan282, %1262, !dbg !1096
  %1263 = or i1 %is_snan283, false, !dbg !1096
  %1264 = bitcast float %1252 to i32, !dbg !1096
  %1265 = and i32 %1264, 2147483647, !dbg !1096
  %is_zero284 = icmp eq i32 %1265, 0, !dbg !1096
  %1266 = and i1 %is_zero284, false, !dbg !1096
  %1267 = bitcast float %1252 to i32, !dbg !1096
  %1268 = and i32 %1267, 2139095040, !dbg !1096
  %1269 = icmp eq i32 %1268, 2139095040, !dbg !1096
  %1270 = and i32 %1267, 8388607, !dbg !1096
  %1271 = icmp eq i32 %1270, 0, !dbg !1096
  %is_inf285 = and i1 %1269, %1271, !dbg !1096
  %1272 = and i1 %is_inf285, false, !dbg !1096
  %1273 = or i1 %1266, %1272, !dbg !1096
  %1274 = or i1 %1263, %1273, !dbg !1096
  br i1 %1274, label %1275, label %1277, !dbg !1096

1275:                                             ; preds = %1254
  %1276 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1277, !dbg !1096

1277:                                             ; preds = %1254, %1275
  %1278 = fmul float %1252, 0x4170000000000000, !dbg !1096
  %1279 = bitcast float %1252 to i32, !dbg !1096
  %1280 = and i32 %1279, 2139095040, !dbg !1096
  %is_finite286 = icmp ne i32 %1280, 2139095040, !dbg !1096
  %1281 = and i1 true, %is_finite286, !dbg !1096
  %1282 = and i1 %1281, true, !dbg !1096
  %1283 = bitcast float %1278 to i32, !dbg !1096
  %1284 = and i32 %1283, 2139095040, !dbg !1096
  %1285 = icmp eq i32 %1284, 2139095040, !dbg !1096
  %1286 = and i32 %1283, 8388607, !dbg !1096
  %1287 = icmp eq i32 %1286, 0, !dbg !1096
  %is_inf287 = and i1 %1285, %1287, !dbg !1096
  %1288 = bitcast float %1278 to i32, !dbg !1096
  %1289 = and i32 %1288, 2147483647, !dbg !1096
  %is_maxfinite288 = icmp eq i32 %1289, 2139095039, !dbg !1096
  %1290 = bitcast float %1278 to i32, !dbg !1096
  %1291 = and i32 %1290, -2147483648, !dbg !1096
  %1292 = icmp eq i32 %1291, 0, !dbg !1096
  %1293 = icmp ne i32 %1291, 0, !dbg !1096
  %is_pos_inf289 = and i1 %is_inf287, %1292, !dbg !1096
  %is_neg_inf290 = and i1 %is_inf287, %1293, !dbg !1096
  %is_pos_max291 = and i1 %is_maxfinite288, %1292, !dbg !1096
  %is_neg_max292 = and i1 %is_maxfinite288, %1293, !dbg !1096
  %overflow_cond293 = and i1 %1282, %is_inf287, !dbg !1096
  br i1 %overflow_cond293, label %1294, label %1296, !dbg !1096

1294:                                             ; preds = %1277
  %1295 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1296, !dbg !1096

1296:                                             ; preds = %1277, %1294
  %1297 = bitcast float %1252 to i32, !dbg !1096
  %1298 = and i32 %1297, 2139095040, !dbg !1096
  %1299 = icmp eq i32 %1298, 0, !dbg !1096
  %1300 = and i32 %1297, 8388607, !dbg !1096
  %1301 = icmp ne i32 %1300, 0, !dbg !1096
  %is_subnormal294 = and i1 %1299, %1301, !dbg !1096
  %1302 = xor i1 %is_subnormal294, true, !dbg !1096
  %1303 = and i1 true, %1302, !dbg !1096
  %1304 = and i1 %1303, true, !dbg !1096
  %1305 = bitcast float %1278 to i32, !dbg !1096
  %1306 = and i32 %1305, 2139095040, !dbg !1096
  %1307 = icmp eq i32 %1306, 0, !dbg !1096
  %1308 = and i32 %1305, 8388607, !dbg !1096
  %1309 = icmp ne i32 %1308, 0, !dbg !1096
  %is_subnormal295 = and i1 %1307, %1309, !dbg !1096
  %1310 = bitcast float %1278 to i32, !dbg !1096
  %1311 = and i32 %1310, 2147483647, !dbg !1096
  %is_zero296 = icmp eq i32 %1311, 0, !dbg !1096
  %1312 = bitcast float %1252 to i32, !dbg !1096
  %1313 = and i32 %1312, 2147483647, !dbg !1096
  %is_zero297 = icmp eq i32 %1313, 0, !dbg !1096
  %1314 = xor i1 %is_zero297, true, !dbg !1096
  %1315 = and i1 %1314, true, !dbg !1096
  %1316 = and i1 %is_zero296, %1315, !dbg !1096
  %is_tiny298 = or i1 %is_subnormal295, %1316, !dbg !1096
  %underflow_cond299 = and i1 %1304, %is_tiny298, !dbg !1096
  br i1 %underflow_cond299, label %1317, label %1319, !dbg !1096

1317:                                             ; preds = %1296
  %1318 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1319, !dbg !1096

1319:                                             ; preds = %1296, %1317
  %1320 = bitcast float %1252 to i32, !dbg !1096
  %1321 = and i32 %1320, 2139095040, !dbg !1096
  %1322 = icmp eq i32 %1321, 0, !dbg !1096
  %1323 = and i32 %1320, 8388607, !dbg !1096
  %1324 = icmp ne i32 %1323, 0, !dbg !1096
  %is_subnormal300 = and i1 %1322, %1324, !dbg !1096
  %1325 = xor i1 %is_subnormal300, true, !dbg !1096
  %1326 = and i1 true, %1325, !dbg !1096
  %1327 = and i1 %1326, true, !dbg !1096
  %1328 = bitcast float %1278 to i32, !dbg !1096
  %1329 = and i32 %1328, 2139095040, !dbg !1096
  %1330 = icmp eq i32 %1329, 0, !dbg !1096
  %1331 = and i32 %1328, 8388607, !dbg !1096
  %1332 = icmp ne i32 %1331, 0, !dbg !1096
  %is_subnormal301 = and i1 %1330, %1332, !dbg !1096
  %subnormal_cond302 = and i1 %1327, %is_subnormal301, !dbg !1096
  br i1 %subnormal_cond302, label %1333, label %1335, !dbg !1096

1333:                                             ; preds = %1319
  %1334 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1335, !dbg !1096

1335:                                             ; preds = %1319, %1333
  br label %1336, !dbg !1096

1336:                                             ; preds = %1335, %1248
  %.013.i = phi float [ %1278, %1335 ], [ %1252, %1248 ], !dbg !1096
  %expo.i.i.0.i = phi float [ -2.400000e+01, %1335 ], [ 0.000000e+00, %1248 ], !dbg !1096
  %1337 = bitcast float %.013.i to i32, !dbg !1096
  %1338 = sub i32 %1337, 1060439283, !dbg !1096
  %1339 = and i32 %1338, -8388608, !dbg !1096
  %1340 = bitcast float %.013.i to i32, !dbg !1096
  %1341 = sub i32 %1340, %1339, !dbg !1096
  %1342 = bitcast i32 %1341 to float, !dbg !1096
  %1343 = sitofp i32 %1339 to float, !dbg !1096
  %1344 = bitcast float %1343 to i32, !dbg !1096
  %1345 = bitcast float %1343 to i32, !dbg !1096
  %1346 = and i32 %1345, 2139095040, !dbg !1096
  %1347 = icmp eq i32 %1346, 2139095040, !dbg !1096
  %1348 = and i32 %1345, 8388607, !dbg !1096
  %1349 = icmp ne i32 %1348, 0, !dbg !1096
  %is_nan303 = and i1 %1347, %1349, !dbg !1096
  %1350 = and i32 %1344, 4194304, !dbg !1096
  %1351 = icmp eq i32 %1350, 0, !dbg !1096
  %is_snan304 = and i1 %is_nan303, %1351, !dbg !1096
  %1352 = or i1 %is_snan304, false, !dbg !1096
  %1353 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1354 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1355 = and i32 %1354, 2139095040, !dbg !1096
  %1356 = icmp eq i32 %1355, 2139095040, !dbg !1096
  %1357 = and i32 %1354, 8388607, !dbg !1096
  %1358 = icmp ne i32 %1357, 0, !dbg !1096
  %is_nan305 = and i1 %1356, %1358, !dbg !1096
  %1359 = and i32 %1353, 4194304, !dbg !1096
  %1360 = icmp eq i32 %1359, 0, !dbg !1096
  %is_snan306 = and i1 %is_nan305, %1360, !dbg !1096
  %1361 = or i1 %1352, %is_snan306, !dbg !1096
  %1362 = bitcast float %1343 to i32, !dbg !1096
  %1363 = and i32 %1362, 2147483647, !dbg !1096
  %is_zero307 = icmp eq i32 %1363, 0, !dbg !1096
  %1364 = and i1 %is_zero307, false, !dbg !1096
  %1365 = bitcast float %1343 to i32, !dbg !1096
  %1366 = and i32 %1365, 2139095040, !dbg !1096
  %1367 = icmp eq i32 %1366, 2139095040, !dbg !1096
  %1368 = and i32 %1365, 8388607, !dbg !1096
  %1369 = icmp eq i32 %1368, 0, !dbg !1096
  %is_inf308 = and i1 %1367, %1369, !dbg !1096
  %1370 = and i1 %is_inf308, false, !dbg !1096
  %1371 = or i1 %1364, %1370, !dbg !1096
  %1372 = or i1 %1361, %1371, !dbg !1096
  br i1 %1372, label %1373, label %1375, !dbg !1096

1373:                                             ; preds = %1336
  %1374 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1375, !dbg !1096

1375:                                             ; preds = %1336, %1373
  %1376 = call float @llvm.nvvm.fma.rn.f(float %1343, float 0x3E80000000000000, float %expo.i.i.0.i) #5, !dbg !1096
  %1377 = bitcast float %1343 to i32, !dbg !1096
  %1378 = and i32 %1377, 2139095040, !dbg !1096
  %is_finite309 = icmp ne i32 %1378, 2139095040, !dbg !1096
  %1379 = and i1 true, %is_finite309, !dbg !1096
  %1380 = and i1 %1379, true, !dbg !1096
  %1381 = bitcast float %1376 to i32, !dbg !1096
  %1382 = and i32 %1381, 2139095040, !dbg !1096
  %1383 = icmp eq i32 %1382, 2139095040, !dbg !1096
  %1384 = and i32 %1381, 8388607, !dbg !1096
  %1385 = icmp eq i32 %1384, 0, !dbg !1096
  %is_inf310 = and i1 %1383, %1385, !dbg !1096
  %1386 = bitcast float %1376 to i32, !dbg !1096
  %1387 = and i32 %1386, 2147483647, !dbg !1096
  %is_maxfinite311 = icmp eq i32 %1387, 2139095039, !dbg !1096
  %1388 = bitcast float %1376 to i32, !dbg !1096
  %1389 = and i32 %1388, -2147483648, !dbg !1096
  %1390 = icmp eq i32 %1389, 0, !dbg !1096
  %1391 = icmp ne i32 %1389, 0, !dbg !1096
  %is_pos_inf312 = and i1 %is_inf310, %1390, !dbg !1096
  %is_neg_inf313 = and i1 %is_inf310, %1391, !dbg !1096
  %is_pos_max314 = and i1 %is_maxfinite311, %1390, !dbg !1096
  %is_neg_max315 = and i1 %is_maxfinite311, %1391, !dbg !1096
  %overflow_cond316 = and i1 %1380, %is_inf310, !dbg !1096
  br i1 %overflow_cond316, label %1392, label %1394, !dbg !1096

1392:                                             ; preds = %1375
  %1393 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1394, !dbg !1096

1394:                                             ; preds = %1375, %1392
  %1395 = bitcast float %1343 to i32, !dbg !1096
  %1396 = and i32 %1395, 2139095040, !dbg !1096
  %1397 = icmp eq i32 %1396, 0, !dbg !1096
  %1398 = and i32 %1395, 8388607, !dbg !1096
  %1399 = icmp ne i32 %1398, 0, !dbg !1096
  %is_subnormal317 = and i1 %1397, %1399, !dbg !1096
  %1400 = xor i1 %is_subnormal317, true, !dbg !1096
  %1401 = and i1 true, %1400, !dbg !1096
  %1402 = and i1 %1401, true, !dbg !1096
  %1403 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1404 = and i32 %1403, 2139095040, !dbg !1096
  %1405 = icmp eq i32 %1404, 0, !dbg !1096
  %1406 = and i32 %1403, 8388607, !dbg !1096
  %1407 = icmp ne i32 %1406, 0, !dbg !1096
  %is_subnormal318 = and i1 %1405, %1407, !dbg !1096
  %1408 = xor i1 %is_subnormal318, true, !dbg !1096
  %1409 = and i1 %1402, %1408, !dbg !1096
  %1410 = bitcast float %1376 to i32, !dbg !1096
  %1411 = and i32 %1410, 2139095040, !dbg !1096
  %1412 = icmp eq i32 %1411, 0, !dbg !1096
  %1413 = and i32 %1410, 8388607, !dbg !1096
  %1414 = icmp ne i32 %1413, 0, !dbg !1096
  %is_subnormal319 = and i1 %1412, %1414, !dbg !1096
  %1415 = bitcast float %1376 to i32, !dbg !1096
  %1416 = and i32 %1415, 2147483647, !dbg !1096
  %is_zero320 = icmp eq i32 %1416, 0, !dbg !1096
  %1417 = bitcast float %1343 to i32, !dbg !1096
  %1418 = and i32 %1417, 2147483647, !dbg !1096
  %is_zero321 = icmp eq i32 %1418, 0, !dbg !1096
  %1419 = xor i1 %is_zero321, true, !dbg !1096
  %1420 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1421 = and i32 %1420, 2147483647, !dbg !1096
  %is_zero322 = icmp eq i32 %1421, 0, !dbg !1096
  %1422 = xor i1 %is_zero322, true, !dbg !1096
  %1423 = and i1 %1419, true, !dbg !1096
  %1424 = and i1 %1423, %1422, !dbg !1096
  %1425 = and i1 %is_zero320, %1424, !dbg !1096
  %is_tiny323 = or i1 %is_subnormal319, %1425, !dbg !1096
  %underflow_cond324 = and i1 %1409, %is_tiny323, !dbg !1096
  br i1 %underflow_cond324, label %1426, label %1428, !dbg !1096

1426:                                             ; preds = %1394
  %1427 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1428, !dbg !1096

1428:                                             ; preds = %1394, %1426
  %1429 = bitcast float %1343 to i32, !dbg !1096
  %1430 = and i32 %1429, 2139095040, !dbg !1096
  %1431 = icmp eq i32 %1430, 0, !dbg !1096
  %1432 = and i32 %1429, 8388607, !dbg !1096
  %1433 = icmp ne i32 %1432, 0, !dbg !1096
  %is_subnormal325 = and i1 %1431, %1433, !dbg !1096
  %1434 = xor i1 %is_subnormal325, true, !dbg !1096
  %1435 = and i1 true, %1434, !dbg !1096
  %1436 = and i1 %1435, true, !dbg !1096
  %1437 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1438 = and i32 %1437, 2139095040, !dbg !1096
  %1439 = icmp eq i32 %1438, 0, !dbg !1096
  %1440 = and i32 %1437, 8388607, !dbg !1096
  %1441 = icmp ne i32 %1440, 0, !dbg !1096
  %is_subnormal326 = and i1 %1439, %1441, !dbg !1096
  %1442 = xor i1 %is_subnormal326, true, !dbg !1096
  %1443 = and i1 %1436, %1442, !dbg !1096
  %1444 = bitcast float %1376 to i32, !dbg !1096
  %1445 = and i32 %1444, 2139095040, !dbg !1096
  %1446 = icmp eq i32 %1445, 0, !dbg !1096
  %1447 = and i32 %1444, 8388607, !dbg !1096
  %1448 = icmp ne i32 %1447, 0, !dbg !1096
  %is_subnormal327 = and i1 %1446, %1448, !dbg !1096
  %subnormal_cond328 = and i1 %1443, %is_subnormal327, !dbg !1096
  br i1 %subnormal_cond328, label %1449, label %1451, !dbg !1096

1449:                                             ; preds = %1428
  %1450 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1451, !dbg !1096

1451:                                             ; preds = %1428, %1449
  %1452 = bitcast float %1342 to i32, !dbg !1096
  %1453 = bitcast float %1342 to i32, !dbg !1096
  %1454 = and i32 %1453, 2139095040, !dbg !1096
  %1455 = icmp eq i32 %1454, 2139095040, !dbg !1096
  %1456 = and i32 %1453, 8388607, !dbg !1096
  %1457 = icmp ne i32 %1456, 0, !dbg !1096
  %is_nan329 = and i1 %1455, %1457, !dbg !1096
  %1458 = and i32 %1452, 4194304, !dbg !1096
  %1459 = icmp eq i32 %1458, 0, !dbg !1096
  %is_snan330 = and i1 %is_nan329, %1459, !dbg !1096
  %1460 = or i1 %is_snan330, false, !dbg !1096
  %1461 = bitcast float %1342 to i32, !dbg !1096
  %1462 = and i32 %1461, 2139095040, !dbg !1096
  %1463 = icmp eq i32 %1462, 2139095040, !dbg !1096
  %1464 = and i32 %1461, 8388607, !dbg !1096
  %1465 = icmp eq i32 %1464, 0, !dbg !1096
  %is_inf331 = and i1 %1463, %1465, !dbg !1096
  %1466 = and i1 %is_inf331, false, !dbg !1096
  %1467 = bitcast float %1342 to i32, !dbg !1096
  %1468 = and i32 %1467, -2147483648, !dbg !1096
  %1469 = icmp eq i32 %1468, 0, !dbg !1096
  %1470 = and i1 %1466, %1469, !dbg !1096
  %1471 = or i1 %1460, %1470, !dbg !1096
  br i1 %1471, label %1472, label %1474, !dbg !1096

1472:                                             ; preds = %1451
  %1473 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1474, !dbg !1096

1474:                                             ; preds = %1451, %1472
  %1475 = fsub float %1342, 1.000000e+00, !dbg !1096
  %1476 = bitcast float %1342 to i32, !dbg !1096
  %1477 = and i32 %1476, 2139095040, !dbg !1096
  %is_finite332 = icmp ne i32 %1477, 2139095040, !dbg !1096
  %1478 = and i1 true, %is_finite332, !dbg !1096
  %1479 = and i1 %1478, true, !dbg !1096
  %1480 = bitcast float %1475 to i32, !dbg !1096
  %1481 = and i32 %1480, 2139095040, !dbg !1096
  %1482 = icmp eq i32 %1481, 2139095040, !dbg !1096
  %1483 = and i32 %1480, 8388607, !dbg !1096
  %1484 = icmp eq i32 %1483, 0, !dbg !1096
  %is_inf333 = and i1 %1482, %1484, !dbg !1096
  %1485 = bitcast float %1475 to i32, !dbg !1096
  %1486 = and i32 %1485, 2147483647, !dbg !1096
  %is_maxfinite334 = icmp eq i32 %1486, 2139095039, !dbg !1096
  %1487 = bitcast float %1475 to i32, !dbg !1096
  %1488 = and i32 %1487, -2147483648, !dbg !1096
  %1489 = icmp eq i32 %1488, 0, !dbg !1096
  %1490 = icmp ne i32 %1488, 0, !dbg !1096
  %is_pos_inf335 = and i1 %is_inf333, %1489, !dbg !1096
  %is_neg_inf336 = and i1 %is_inf333, %1490, !dbg !1096
  %is_pos_max337 = and i1 %is_maxfinite334, %1489, !dbg !1096
  %is_neg_max338 = and i1 %is_maxfinite334, %1490, !dbg !1096
  %overflow_cond339 = and i1 %1479, %is_inf333, !dbg !1096
  br i1 %overflow_cond339, label %1491, label %1493, !dbg !1096

1491:                                             ; preds = %1474
  %1492 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1493, !dbg !1096

1493:                                             ; preds = %1474, %1491
  %1494 = bitcast float %1342 to i32, !dbg !1096
  %1495 = and i32 %1494, 2139095040, !dbg !1096
  %1496 = icmp eq i32 %1495, 0, !dbg !1096
  %1497 = and i32 %1494, 8388607, !dbg !1096
  %1498 = icmp ne i32 %1497, 0, !dbg !1096
  %is_subnormal340 = and i1 %1496, %1498, !dbg !1096
  %1499 = xor i1 %is_subnormal340, true, !dbg !1096
  %1500 = and i1 true, %1499, !dbg !1096
  %1501 = and i1 %1500, true, !dbg !1096
  %1502 = bitcast float %1475 to i32, !dbg !1096
  %1503 = and i32 %1502, 2139095040, !dbg !1096
  %1504 = icmp eq i32 %1503, 0, !dbg !1096
  %1505 = and i32 %1502, 8388607, !dbg !1096
  %1506 = icmp ne i32 %1505, 0, !dbg !1096
  %is_subnormal341 = and i1 %1504, %1506, !dbg !1096
  %subnormal_cond342 = and i1 %1501, %is_subnormal341, !dbg !1096
  br i1 %subnormal_cond342, label %1507, label %1509, !dbg !1096

1507:                                             ; preds = %1493
  %1508 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1509, !dbg !1096

1509:                                             ; preds = %1493, %1507
  %1510 = bitcast float %1342 to i32, !dbg !1096
  %1511 = bitcast float %1342 to i32, !dbg !1096
  %1512 = and i32 %1511, 2139095040, !dbg !1096
  %1513 = icmp eq i32 %1512, 2139095040, !dbg !1096
  %1514 = and i32 %1511, 8388607, !dbg !1096
  %1515 = icmp ne i32 %1514, 0, !dbg !1096
  %is_nan343 = and i1 %1513, %1515, !dbg !1096
  %1516 = and i32 %1510, 4194304, !dbg !1096
  %1517 = icmp eq i32 %1516, 0, !dbg !1096
  %is_snan344 = and i1 %is_nan343, %1517, !dbg !1096
  %1518 = or i1 %is_snan344, false, !dbg !1096
  %1519 = bitcast float %1342 to i32, !dbg !1096
  %1520 = and i32 %1519, 2139095040, !dbg !1096
  %1521 = icmp eq i32 %1520, 2139095040, !dbg !1096
  %1522 = and i32 %1519, 8388607, !dbg !1096
  %1523 = icmp eq i32 %1522, 0, !dbg !1096
  %is_inf345 = and i1 %1521, %1523, !dbg !1096
  %1524 = and i1 %is_inf345, false, !dbg !1096
  %1525 = bitcast float %1342 to i32, !dbg !1096
  %1526 = and i32 %1525, -2147483648, !dbg !1096
  %1527 = icmp ne i32 %1526, 0, !dbg !1096
  %1528 = and i1 %1524, %1527, !dbg !1096
  %1529 = or i1 %1518, %1528, !dbg !1096
  br i1 %1529, label %1530, label %1532, !dbg !1096

1530:                                             ; preds = %1509
  %1531 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1532, !dbg !1096

1532:                                             ; preds = %1509, %1530
  %1533 = fadd float %1342, 1.000000e+00, !dbg !1096
  %1534 = bitcast float %1342 to i32, !dbg !1096
  %1535 = and i32 %1534, 2139095040, !dbg !1096
  %is_finite346 = icmp ne i32 %1535, 2139095040, !dbg !1096
  %1536 = and i1 true, %is_finite346, !dbg !1096
  %1537 = and i1 %1536, true, !dbg !1096
  %1538 = bitcast float %1533 to i32, !dbg !1096
  %1539 = and i32 %1538, 2139095040, !dbg !1096
  %1540 = icmp eq i32 %1539, 2139095040, !dbg !1096
  %1541 = and i32 %1538, 8388607, !dbg !1096
  %1542 = icmp eq i32 %1541, 0, !dbg !1096
  %is_inf347 = and i1 %1540, %1542, !dbg !1096
  %1543 = bitcast float %1533 to i32, !dbg !1096
  %1544 = and i32 %1543, 2147483647, !dbg !1096
  %is_maxfinite348 = icmp eq i32 %1544, 2139095039, !dbg !1096
  %1545 = bitcast float %1533 to i32, !dbg !1096
  %1546 = and i32 %1545, -2147483648, !dbg !1096
  %1547 = icmp eq i32 %1546, 0, !dbg !1096
  %1548 = icmp ne i32 %1546, 0, !dbg !1096
  %is_pos_inf349 = and i1 %is_inf347, %1547, !dbg !1096
  %is_neg_inf350 = and i1 %is_inf347, %1548, !dbg !1096
  %is_pos_max351 = and i1 %is_maxfinite348, %1547, !dbg !1096
  %is_neg_max352 = and i1 %is_maxfinite348, %1548, !dbg !1096
  %overflow_cond353 = and i1 %1537, %is_inf347, !dbg !1096
  br i1 %overflow_cond353, label %1549, label %1551, !dbg !1096

1549:                                             ; preds = %1532
  %1550 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1551, !dbg !1096

1551:                                             ; preds = %1532, %1549
  %1552 = bitcast float %1342 to i32, !dbg !1096
  %1553 = and i32 %1552, 2139095040, !dbg !1096
  %1554 = icmp eq i32 %1553, 0, !dbg !1096
  %1555 = and i32 %1552, 8388607, !dbg !1096
  %1556 = icmp ne i32 %1555, 0, !dbg !1096
  %is_subnormal354 = and i1 %1554, %1556, !dbg !1096
  %1557 = xor i1 %is_subnormal354, true, !dbg !1096
  %1558 = and i1 true, %1557, !dbg !1096
  %1559 = and i1 %1558, true, !dbg !1096
  %1560 = bitcast float %1533 to i32, !dbg !1096
  %1561 = and i32 %1560, 2139095040, !dbg !1096
  %1562 = icmp eq i32 %1561, 0, !dbg !1096
  %1563 = and i32 %1560, 8388607, !dbg !1096
  %1564 = icmp ne i32 %1563, 0, !dbg !1096
  %is_subnormal355 = and i1 %1562, %1564, !dbg !1096
  %subnormal_cond356 = and i1 %1559, %is_subnormal355, !dbg !1096
  br i1 %subnormal_cond356, label %1565, label %1567, !dbg !1096

1565:                                             ; preds = %1551
  %1566 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1567, !dbg !1096

1567:                                             ; preds = %1551, %1565
  %1568 = call float asm "rcp.approx.ftz.f32 $0,$1;", "=f,f"(float %1533) #6, !dbg !1096, !srcloc !1097
  %1569 = bitcast float %1475 to i32, !dbg !1096
  %1570 = bitcast float %1475 to i32, !dbg !1096
  %1571 = and i32 %1570, 2139095040, !dbg !1096
  %1572 = icmp eq i32 %1571, 2139095040, !dbg !1096
  %1573 = and i32 %1570, 8388607, !dbg !1096
  %1574 = icmp ne i32 %1573, 0, !dbg !1096
  %is_nan357 = and i1 %1572, %1574, !dbg !1096
  %1575 = and i32 %1569, 4194304, !dbg !1096
  %1576 = icmp eq i32 %1575, 0, !dbg !1096
  %is_snan358 = and i1 %is_nan357, %1576, !dbg !1096
  %1577 = or i1 false, %is_snan358, !dbg !1096
  %1578 = bitcast float %1475 to i32, !dbg !1096
  %1579 = and i32 %1578, 2139095040, !dbg !1096
  %1580 = icmp eq i32 %1579, 2139095040, !dbg !1096
  %1581 = and i32 %1578, 8388607, !dbg !1096
  %1582 = icmp eq i32 %1581, 0, !dbg !1096
  %is_inf359 = and i1 %1580, %1582, !dbg !1096
  %1583 = and i1 false, %is_inf359, !dbg !1096
  %1584 = bitcast float %1475 to i32, !dbg !1096
  %1585 = and i32 %1584, 2147483647, !dbg !1096
  %is_zero360 = icmp eq i32 %1585, 0, !dbg !1096
  %1586 = and i1 false, %is_zero360, !dbg !1096
  %1587 = or i1 %1583, %1586, !dbg !1096
  %1588 = or i1 %1577, %1587, !dbg !1096
  br i1 %1588, label %1589, label %1591, !dbg !1096

1589:                                             ; preds = %1567
  %1590 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1591, !dbg !1096

1591:                                             ; preds = %1567, %1589
  %1592 = fmul float 2.000000e+00, %1475, !dbg !1096
  %1593 = bitcast float %1475 to i32, !dbg !1096
  %1594 = and i32 %1593, 2139095040, !dbg !1096
  %is_finite361 = icmp ne i32 %1594, 2139095040, !dbg !1096
  %1595 = and i1 true, %is_finite361, !dbg !1096
  %1596 = bitcast float %1592 to i32, !dbg !1096
  %1597 = and i32 %1596, 2139095040, !dbg !1096
  %1598 = icmp eq i32 %1597, 2139095040, !dbg !1096
  %1599 = and i32 %1596, 8388607, !dbg !1096
  %1600 = icmp eq i32 %1599, 0, !dbg !1096
  %is_inf362 = and i1 %1598, %1600, !dbg !1096
  %1601 = bitcast float %1592 to i32, !dbg !1096
  %1602 = and i32 %1601, 2147483647, !dbg !1096
  %is_maxfinite363 = icmp eq i32 %1602, 2139095039, !dbg !1096
  %1603 = bitcast float %1592 to i32, !dbg !1096
  %1604 = and i32 %1603, -2147483648, !dbg !1096
  %1605 = icmp eq i32 %1604, 0, !dbg !1096
  %1606 = icmp ne i32 %1604, 0, !dbg !1096
  %is_pos_inf364 = and i1 %is_inf362, %1605, !dbg !1096
  %is_neg_inf365 = and i1 %is_inf362, %1606, !dbg !1096
  %is_pos_max366 = and i1 %is_maxfinite363, %1605, !dbg !1096
  %is_neg_max367 = and i1 %is_maxfinite363, %1606, !dbg !1096
  %overflow_cond368 = and i1 %1595, %is_inf362, !dbg !1096
  br i1 %overflow_cond368, label %1607, label %1609, !dbg !1096

1607:                                             ; preds = %1591
  %1608 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1609, !dbg !1096

1609:                                             ; preds = %1591, %1607
  %1610 = bitcast float %1475 to i32, !dbg !1096
  %1611 = and i32 %1610, 2139095040, !dbg !1096
  %1612 = icmp eq i32 %1611, 0, !dbg !1096
  %1613 = and i32 %1610, 8388607, !dbg !1096
  %1614 = icmp ne i32 %1613, 0, !dbg !1096
  %is_subnormal369 = and i1 %1612, %1614, !dbg !1096
  %1615 = xor i1 %is_subnormal369, true, !dbg !1096
  %1616 = and i1 true, %1615, !dbg !1096
  %1617 = bitcast float %1592 to i32, !dbg !1096
  %1618 = and i32 %1617, 2139095040, !dbg !1096
  %1619 = icmp eq i32 %1618, 0, !dbg !1096
  %1620 = and i32 %1617, 8388607, !dbg !1096
  %1621 = icmp ne i32 %1620, 0, !dbg !1096
  %is_subnormal370 = and i1 %1619, %1621, !dbg !1096
  %1622 = bitcast float %1592 to i32, !dbg !1096
  %1623 = and i32 %1622, 2147483647, !dbg !1096
  %is_zero371 = icmp eq i32 %1623, 0, !dbg !1096
  %1624 = bitcast float %1475 to i32, !dbg !1096
  %1625 = and i32 %1624, 2147483647, !dbg !1096
  %is_zero372 = icmp eq i32 %1625, 0, !dbg !1096
  %1626 = xor i1 %is_zero372, true, !dbg !1096
  %1627 = and i1 true, %1626, !dbg !1096
  %1628 = and i1 %is_zero371, %1627, !dbg !1096
  %is_tiny373 = or i1 %is_subnormal370, %1628, !dbg !1096
  %underflow_cond374 = and i1 %1616, %is_tiny373, !dbg !1096
  br i1 %underflow_cond374, label %1629, label %1631, !dbg !1096

1629:                                             ; preds = %1609
  %1630 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1631, !dbg !1096

1631:                                             ; preds = %1609, %1629
  %1632 = bitcast float %1475 to i32, !dbg !1096
  %1633 = and i32 %1632, 2139095040, !dbg !1096
  %1634 = icmp eq i32 %1633, 0, !dbg !1096
  %1635 = and i32 %1632, 8388607, !dbg !1096
  %1636 = icmp ne i32 %1635, 0, !dbg !1096
  %is_subnormal375 = and i1 %1634, %1636, !dbg !1096
  %1637 = xor i1 %is_subnormal375, true, !dbg !1096
  %1638 = and i1 true, %1637, !dbg !1096
  %1639 = bitcast float %1592 to i32, !dbg !1096
  %1640 = and i32 %1639, 2139095040, !dbg !1096
  %1641 = icmp eq i32 %1640, 0, !dbg !1096
  %1642 = and i32 %1639, 8388607, !dbg !1096
  %1643 = icmp ne i32 %1642, 0, !dbg !1096
  %is_subnormal376 = and i1 %1641, %1643, !dbg !1096
  %subnormal_cond377 = and i1 %1638, %is_subnormal376, !dbg !1096
  br i1 %subnormal_cond377, label %1644, label %1646, !dbg !1096

1644:                                             ; preds = %1631
  %1645 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1646, !dbg !1096

1646:                                             ; preds = %1631, %1644
  %1647 = bitcast float %1592 to i32, !dbg !1096
  %1648 = bitcast float %1592 to i32, !dbg !1096
  %1649 = and i32 %1648, 2139095040, !dbg !1096
  %1650 = icmp eq i32 %1649, 2139095040, !dbg !1096
  %1651 = and i32 %1648, 8388607, !dbg !1096
  %1652 = icmp ne i32 %1651, 0, !dbg !1096
  %is_nan378 = and i1 %1650, %1652, !dbg !1096
  %1653 = and i32 %1647, 4194304, !dbg !1096
  %1654 = icmp eq i32 %1653, 0, !dbg !1096
  %is_snan379 = and i1 %is_nan378, %1654, !dbg !1096
  %1655 = bitcast float %1568 to i32, !dbg !1096
  %1656 = bitcast float %1568 to i32, !dbg !1096
  %1657 = and i32 %1656, 2139095040, !dbg !1096
  %1658 = icmp eq i32 %1657, 2139095040, !dbg !1096
  %1659 = and i32 %1656, 8388607, !dbg !1096
  %1660 = icmp ne i32 %1659, 0, !dbg !1096
  %is_nan380 = and i1 %1658, %1660, !dbg !1096
  %1661 = and i32 %1655, 4194304, !dbg !1096
  %1662 = icmp eq i32 %1661, 0, !dbg !1096
  %is_snan381 = and i1 %is_nan380, %1662, !dbg !1096
  %1663 = or i1 %is_snan379, %is_snan381, !dbg !1096
  %1664 = bitcast float %1592 to i32, !dbg !1096
  %1665 = and i32 %1664, 2147483647, !dbg !1096
  %is_zero382 = icmp eq i32 %1665, 0, !dbg !1096
  %1666 = bitcast float %1568 to i32, !dbg !1096
  %1667 = and i32 %1666, 2139095040, !dbg !1096
  %1668 = icmp eq i32 %1667, 2139095040, !dbg !1096
  %1669 = and i32 %1666, 8388607, !dbg !1096
  %1670 = icmp eq i32 %1669, 0, !dbg !1096
  %is_inf383 = and i1 %1668, %1670, !dbg !1096
  %1671 = and i1 %is_zero382, %is_inf383, !dbg !1096
  %1672 = bitcast float %1592 to i32, !dbg !1096
  %1673 = and i32 %1672, 2139095040, !dbg !1096
  %1674 = icmp eq i32 %1673, 2139095040, !dbg !1096
  %1675 = and i32 %1672, 8388607, !dbg !1096
  %1676 = icmp eq i32 %1675, 0, !dbg !1096
  %is_inf384 = and i1 %1674, %1676, !dbg !1096
  %1677 = bitcast float %1568 to i32, !dbg !1096
  %1678 = and i32 %1677, 2147483647, !dbg !1096
  %is_zero385 = icmp eq i32 %1678, 0, !dbg !1096
  %1679 = and i1 %is_inf384, %is_zero385, !dbg !1096
  %1680 = or i1 %1671, %1679, !dbg !1096
  %1681 = or i1 %1663, %1680, !dbg !1096
  br i1 %1681, label %1682, label %1684, !dbg !1096

1682:                                             ; preds = %1646
  %1683 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1684, !dbg !1096

1684:                                             ; preds = %1646, %1682
  %1685 = fmul float %1592, %1568, !dbg !1096
  %1686 = bitcast float %1592 to i32, !dbg !1096
  %1687 = and i32 %1686, 2139095040, !dbg !1096
  %is_finite386 = icmp ne i32 %1687, 2139095040, !dbg !1096
  %1688 = and i1 true, %is_finite386, !dbg !1096
  %1689 = bitcast float %1568 to i32, !dbg !1096
  %1690 = and i32 %1689, 2139095040, !dbg !1096
  %is_finite387 = icmp ne i32 %1690, 2139095040, !dbg !1096
  %1691 = and i1 %1688, %is_finite387, !dbg !1096
  %1692 = bitcast float %1685 to i32, !dbg !1096
  %1693 = and i32 %1692, 2139095040, !dbg !1096
  %1694 = icmp eq i32 %1693, 2139095040, !dbg !1096
  %1695 = and i32 %1692, 8388607, !dbg !1096
  %1696 = icmp eq i32 %1695, 0, !dbg !1096
  %is_inf388 = and i1 %1694, %1696, !dbg !1096
  %1697 = bitcast float %1685 to i32, !dbg !1096
  %1698 = and i32 %1697, 2147483647, !dbg !1096
  %is_maxfinite389 = icmp eq i32 %1698, 2139095039, !dbg !1096
  %1699 = bitcast float %1685 to i32, !dbg !1096
  %1700 = and i32 %1699, -2147483648, !dbg !1096
  %1701 = icmp eq i32 %1700, 0, !dbg !1096
  %1702 = icmp ne i32 %1700, 0, !dbg !1096
  %is_pos_inf390 = and i1 %is_inf388, %1701, !dbg !1096
  %is_neg_inf391 = and i1 %is_inf388, %1702, !dbg !1096
  %is_pos_max392 = and i1 %is_maxfinite389, %1701, !dbg !1096
  %is_neg_max393 = and i1 %is_maxfinite389, %1702, !dbg !1096
  %overflow_cond394 = and i1 %1691, %is_inf388, !dbg !1096
  br i1 %overflow_cond394, label %1703, label %1705, !dbg !1096

1703:                                             ; preds = %1684
  %1704 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1705, !dbg !1096

1705:                                             ; preds = %1684, %1703
  %1706 = bitcast float %1592 to i32, !dbg !1096
  %1707 = and i32 %1706, 2139095040, !dbg !1096
  %1708 = icmp eq i32 %1707, 0, !dbg !1096
  %1709 = and i32 %1706, 8388607, !dbg !1096
  %1710 = icmp ne i32 %1709, 0, !dbg !1096
  %is_subnormal395 = and i1 %1708, %1710, !dbg !1096
  %1711 = xor i1 %is_subnormal395, true, !dbg !1096
  %1712 = and i1 true, %1711, !dbg !1096
  %1713 = bitcast float %1568 to i32, !dbg !1096
  %1714 = and i32 %1713, 2139095040, !dbg !1096
  %1715 = icmp eq i32 %1714, 0, !dbg !1096
  %1716 = and i32 %1713, 8388607, !dbg !1096
  %1717 = icmp ne i32 %1716, 0, !dbg !1096
  %is_subnormal396 = and i1 %1715, %1717, !dbg !1096
  %1718 = xor i1 %is_subnormal396, true, !dbg !1096
  %1719 = and i1 %1712, %1718, !dbg !1096
  %1720 = bitcast float %1685 to i32, !dbg !1096
  %1721 = and i32 %1720, 2139095040, !dbg !1096
  %1722 = icmp eq i32 %1721, 0, !dbg !1096
  %1723 = and i32 %1720, 8388607, !dbg !1096
  %1724 = icmp ne i32 %1723, 0, !dbg !1096
  %is_subnormal397 = and i1 %1722, %1724, !dbg !1096
  %1725 = bitcast float %1685 to i32, !dbg !1096
  %1726 = and i32 %1725, 2147483647, !dbg !1096
  %is_zero398 = icmp eq i32 %1726, 0, !dbg !1096
  %1727 = bitcast float %1592 to i32, !dbg !1096
  %1728 = and i32 %1727, 2147483647, !dbg !1096
  %is_zero399 = icmp eq i32 %1728, 0, !dbg !1096
  %1729 = xor i1 %is_zero399, true, !dbg !1096
  %1730 = bitcast float %1568 to i32, !dbg !1096
  %1731 = and i32 %1730, 2147483647, !dbg !1096
  %is_zero400 = icmp eq i32 %1731, 0, !dbg !1096
  %1732 = xor i1 %is_zero400, true, !dbg !1096
  %1733 = and i1 %1729, %1732, !dbg !1096
  %1734 = and i1 %is_zero398, %1733, !dbg !1096
  %is_tiny401 = or i1 %is_subnormal397, %1734, !dbg !1096
  %underflow_cond402 = and i1 %1719, %is_tiny401, !dbg !1096
  br i1 %underflow_cond402, label %1735, label %1737, !dbg !1096

1735:                                             ; preds = %1705
  %1736 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1737, !dbg !1096

1737:                                             ; preds = %1705, %1735
  %1738 = bitcast float %1592 to i32, !dbg !1096
  %1739 = and i32 %1738, 2139095040, !dbg !1096
  %1740 = icmp eq i32 %1739, 0, !dbg !1096
  %1741 = and i32 %1738, 8388607, !dbg !1096
  %1742 = icmp ne i32 %1741, 0, !dbg !1096
  %is_subnormal403 = and i1 %1740, %1742, !dbg !1096
  %1743 = xor i1 %is_subnormal403, true, !dbg !1096
  %1744 = and i1 true, %1743, !dbg !1096
  %1745 = bitcast float %1568 to i32, !dbg !1096
  %1746 = and i32 %1745, 2139095040, !dbg !1096
  %1747 = icmp eq i32 %1746, 0, !dbg !1096
  %1748 = and i32 %1745, 8388607, !dbg !1096
  %1749 = icmp ne i32 %1748, 0, !dbg !1096
  %is_subnormal404 = and i1 %1747, %1749, !dbg !1096
  %1750 = xor i1 %is_subnormal404, true, !dbg !1096
  %1751 = and i1 %1744, %1750, !dbg !1096
  %1752 = bitcast float %1685 to i32, !dbg !1096
  %1753 = and i32 %1752, 2139095040, !dbg !1096
  %1754 = icmp eq i32 %1753, 0, !dbg !1096
  %1755 = and i32 %1752, 8388607, !dbg !1096
  %1756 = icmp ne i32 %1755, 0, !dbg !1096
  %is_subnormal405 = and i1 %1754, %1756, !dbg !1096
  %subnormal_cond406 = and i1 %1751, %is_subnormal405, !dbg !1096
  br i1 %subnormal_cond406, label %1757, label %1759, !dbg !1096

1757:                                             ; preds = %1737
  %1758 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1759, !dbg !1096

1759:                                             ; preds = %1737, %1757
  %1760 = bitcast float %1685 to i32, !dbg !1096
  %1761 = bitcast float %1685 to i32, !dbg !1096
  %1762 = and i32 %1761, 2139095040, !dbg !1096
  %1763 = icmp eq i32 %1762, 2139095040, !dbg !1096
  %1764 = and i32 %1761, 8388607, !dbg !1096
  %1765 = icmp ne i32 %1764, 0, !dbg !1096
  %is_nan407 = and i1 %1763, %1765, !dbg !1096
  %1766 = and i32 %1760, 4194304, !dbg !1096
  %1767 = icmp eq i32 %1766, 0, !dbg !1096
  %is_snan408 = and i1 %is_nan407, %1767, !dbg !1096
  %1768 = bitcast float %1685 to i32, !dbg !1096
  %1769 = bitcast float %1685 to i32, !dbg !1096
  %1770 = and i32 %1769, 2139095040, !dbg !1096
  %1771 = icmp eq i32 %1770, 2139095040, !dbg !1096
  %1772 = and i32 %1769, 8388607, !dbg !1096
  %1773 = icmp ne i32 %1772, 0, !dbg !1096
  %is_nan409 = and i1 %1771, %1773, !dbg !1096
  %1774 = and i32 %1768, 4194304, !dbg !1096
  %1775 = icmp eq i32 %1774, 0, !dbg !1096
  %is_snan410 = and i1 %is_nan409, %1775, !dbg !1096
  %1776 = or i1 %is_snan408, %is_snan410, !dbg !1096
  %1777 = bitcast float %1685 to i32, !dbg !1096
  %1778 = and i32 %1777, 2147483647, !dbg !1096
  %is_zero411 = icmp eq i32 %1778, 0, !dbg !1096
  %1779 = bitcast float %1685 to i32, !dbg !1096
  %1780 = and i32 %1779, 2139095040, !dbg !1096
  %1781 = icmp eq i32 %1780, 2139095040, !dbg !1096
  %1782 = and i32 %1779, 8388607, !dbg !1096
  %1783 = icmp eq i32 %1782, 0, !dbg !1096
  %is_inf412 = and i1 %1781, %1783, !dbg !1096
  %1784 = and i1 %is_zero411, %is_inf412, !dbg !1096
  %1785 = bitcast float %1685 to i32, !dbg !1096
  %1786 = and i32 %1785, 2139095040, !dbg !1096
  %1787 = icmp eq i32 %1786, 2139095040, !dbg !1096
  %1788 = and i32 %1785, 8388607, !dbg !1096
  %1789 = icmp eq i32 %1788, 0, !dbg !1096
  %is_inf413 = and i1 %1787, %1789, !dbg !1096
  %1790 = bitcast float %1685 to i32, !dbg !1096
  %1791 = and i32 %1790, 2147483647, !dbg !1096
  %is_zero414 = icmp eq i32 %1791, 0, !dbg !1096
  %1792 = and i1 %is_inf413, %is_zero414, !dbg !1096
  %1793 = or i1 %1784, %1792, !dbg !1096
  %1794 = or i1 %1776, %1793, !dbg !1096
  br i1 %1794, label %1795, label %1797, !dbg !1096

1795:                                             ; preds = %1759
  %1796 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1797, !dbg !1096

1797:                                             ; preds = %1759, %1795
  %1798 = fmul float %1685, %1685, !dbg !1096
  %1799 = bitcast float %1685 to i32, !dbg !1096
  %1800 = and i32 %1799, 2139095040, !dbg !1096
  %is_finite415 = icmp ne i32 %1800, 2139095040, !dbg !1096
  %1801 = and i1 true, %is_finite415, !dbg !1096
  %1802 = bitcast float %1685 to i32, !dbg !1096
  %1803 = and i32 %1802, 2139095040, !dbg !1096
  %is_finite416 = icmp ne i32 %1803, 2139095040, !dbg !1096
  %1804 = and i1 %1801, %is_finite416, !dbg !1096
  %1805 = bitcast float %1798 to i32, !dbg !1096
  %1806 = and i32 %1805, 2139095040, !dbg !1096
  %1807 = icmp eq i32 %1806, 2139095040, !dbg !1096
  %1808 = and i32 %1805, 8388607, !dbg !1096
  %1809 = icmp eq i32 %1808, 0, !dbg !1096
  %is_inf417 = and i1 %1807, %1809, !dbg !1096
  %1810 = bitcast float %1798 to i32, !dbg !1096
  %1811 = and i32 %1810, 2147483647, !dbg !1096
  %is_maxfinite418 = icmp eq i32 %1811, 2139095039, !dbg !1096
  %1812 = bitcast float %1798 to i32, !dbg !1096
  %1813 = and i32 %1812, -2147483648, !dbg !1096
  %1814 = icmp eq i32 %1813, 0, !dbg !1096
  %1815 = icmp ne i32 %1813, 0, !dbg !1096
  %is_pos_inf419 = and i1 %is_inf417, %1814, !dbg !1096
  %is_neg_inf420 = and i1 %is_inf417, %1815, !dbg !1096
  %is_pos_max421 = and i1 %is_maxfinite418, %1814, !dbg !1096
  %is_neg_max422 = and i1 %is_maxfinite418, %1815, !dbg !1096
  %overflow_cond423 = and i1 %1804, %is_inf417, !dbg !1096
  br i1 %overflow_cond423, label %1816, label %1818, !dbg !1096

1816:                                             ; preds = %1797
  %1817 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1818, !dbg !1096

1818:                                             ; preds = %1797, %1816
  %1819 = bitcast float %1685 to i32, !dbg !1096
  %1820 = and i32 %1819, 2139095040, !dbg !1096
  %1821 = icmp eq i32 %1820, 0, !dbg !1096
  %1822 = and i32 %1819, 8388607, !dbg !1096
  %1823 = icmp ne i32 %1822, 0, !dbg !1096
  %is_subnormal424 = and i1 %1821, %1823, !dbg !1096
  %1824 = xor i1 %is_subnormal424, true, !dbg !1096
  %1825 = and i1 true, %1824, !dbg !1096
  %1826 = bitcast float %1685 to i32, !dbg !1096
  %1827 = and i32 %1826, 2139095040, !dbg !1096
  %1828 = icmp eq i32 %1827, 0, !dbg !1096
  %1829 = and i32 %1826, 8388607, !dbg !1096
  %1830 = icmp ne i32 %1829, 0, !dbg !1096
  %is_subnormal425 = and i1 %1828, %1830, !dbg !1096
  %1831 = xor i1 %is_subnormal425, true, !dbg !1096
  %1832 = and i1 %1825, %1831, !dbg !1096
  %1833 = bitcast float %1798 to i32, !dbg !1096
  %1834 = and i32 %1833, 2139095040, !dbg !1096
  %1835 = icmp eq i32 %1834, 0, !dbg !1096
  %1836 = and i32 %1833, 8388607, !dbg !1096
  %1837 = icmp ne i32 %1836, 0, !dbg !1096
  %is_subnormal426 = and i1 %1835, %1837, !dbg !1096
  %1838 = bitcast float %1798 to i32, !dbg !1096
  %1839 = and i32 %1838, 2147483647, !dbg !1096
  %is_zero427 = icmp eq i32 %1839, 0, !dbg !1096
  %1840 = bitcast float %1685 to i32, !dbg !1096
  %1841 = and i32 %1840, 2147483647, !dbg !1096
  %is_zero428 = icmp eq i32 %1841, 0, !dbg !1096
  %1842 = xor i1 %is_zero428, true, !dbg !1096
  %1843 = bitcast float %1685 to i32, !dbg !1096
  %1844 = and i32 %1843, 2147483647, !dbg !1096
  %is_zero429 = icmp eq i32 %1844, 0, !dbg !1096
  %1845 = xor i1 %is_zero429, true, !dbg !1096
  %1846 = and i1 %1842, %1845, !dbg !1096
  %1847 = and i1 %is_zero427, %1846, !dbg !1096
  %is_tiny430 = or i1 %is_subnormal426, %1847, !dbg !1096
  %underflow_cond431 = and i1 %1832, %is_tiny430, !dbg !1096
  br i1 %underflow_cond431, label %1848, label %1850, !dbg !1096

1848:                                             ; preds = %1818
  %1849 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %1850, !dbg !1096

1850:                                             ; preds = %1818, %1848
  %1851 = bitcast float %1685 to i32, !dbg !1096
  %1852 = and i32 %1851, 2139095040, !dbg !1096
  %1853 = icmp eq i32 %1852, 0, !dbg !1096
  %1854 = and i32 %1851, 8388607, !dbg !1096
  %1855 = icmp ne i32 %1854, 0, !dbg !1096
  %is_subnormal432 = and i1 %1853, %1855, !dbg !1096
  %1856 = xor i1 %is_subnormal432, true, !dbg !1096
  %1857 = and i1 true, %1856, !dbg !1096
  %1858 = bitcast float %1685 to i32, !dbg !1096
  %1859 = and i32 %1858, 2139095040, !dbg !1096
  %1860 = icmp eq i32 %1859, 0, !dbg !1096
  %1861 = and i32 %1858, 8388607, !dbg !1096
  %1862 = icmp ne i32 %1861, 0, !dbg !1096
  %is_subnormal433 = and i1 %1860, %1862, !dbg !1096
  %1863 = xor i1 %is_subnormal433, true, !dbg !1096
  %1864 = and i1 %1857, %1863, !dbg !1096
  %1865 = bitcast float %1798 to i32, !dbg !1096
  %1866 = and i32 %1865, 2139095040, !dbg !1096
  %1867 = icmp eq i32 %1866, 0, !dbg !1096
  %1868 = and i32 %1865, 8388607, !dbg !1096
  %1869 = icmp ne i32 %1868, 0, !dbg !1096
  %is_subnormal434 = and i1 %1867, %1869, !dbg !1096
  %subnormal_cond435 = and i1 %1864, %is_subnormal434, !dbg !1096
  br i1 %subnormal_cond435, label %1870, label %1872, !dbg !1096

1870:                                             ; preds = %1850
  %1871 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1872, !dbg !1096

1872:                                             ; preds = %1850, %1870
  %1873 = bitcast float %1475 to i32, !dbg !1096
  %1874 = bitcast float %1475 to i32, !dbg !1096
  %1875 = and i32 %1874, 2139095040, !dbg !1096
  %1876 = icmp eq i32 %1875, 2139095040, !dbg !1096
  %1877 = and i32 %1874, 8388607, !dbg !1096
  %1878 = icmp ne i32 %1877, 0, !dbg !1096
  %is_nan436 = and i1 %1876, %1878, !dbg !1096
  %1879 = and i32 %1873, 4194304, !dbg !1096
  %1880 = icmp eq i32 %1879, 0, !dbg !1096
  %is_snan437 = and i1 %is_nan436, %1880, !dbg !1096
  %1881 = bitcast float %1685 to i32, !dbg !1096
  %1882 = bitcast float %1685 to i32, !dbg !1096
  %1883 = and i32 %1882, 2139095040, !dbg !1096
  %1884 = icmp eq i32 %1883, 2139095040, !dbg !1096
  %1885 = and i32 %1882, 8388607, !dbg !1096
  %1886 = icmp ne i32 %1885, 0, !dbg !1096
  %is_nan438 = and i1 %1884, %1886, !dbg !1096
  %1887 = and i32 %1881, 4194304, !dbg !1096
  %1888 = icmp eq i32 %1887, 0, !dbg !1096
  %is_snan439 = and i1 %is_nan438, %1888, !dbg !1096
  %1889 = or i1 %is_snan437, %is_snan439, !dbg !1096
  %1890 = bitcast float %1475 to i32, !dbg !1096
  %1891 = and i32 %1890, 2139095040, !dbg !1096
  %1892 = icmp eq i32 %1891, 2139095040, !dbg !1096
  %1893 = and i32 %1890, 8388607, !dbg !1096
  %1894 = icmp eq i32 %1893, 0, !dbg !1096
  %is_inf440 = and i1 %1892, %1894, !dbg !1096
  %1895 = bitcast float %1685 to i32, !dbg !1096
  %1896 = and i32 %1895, 2139095040, !dbg !1096
  %1897 = icmp eq i32 %1896, 2139095040, !dbg !1096
  %1898 = and i32 %1895, 8388607, !dbg !1096
  %1899 = icmp eq i32 %1898, 0, !dbg !1096
  %is_inf441 = and i1 %1897, %1899, !dbg !1096
  %1900 = and i1 %is_inf440, %is_inf441, !dbg !1096
  %1901 = bitcast float %1475 to i32, !dbg !1096
  %1902 = bitcast float %1685 to i32, !dbg !1096
  %1903 = and i32 %1901, -2147483648, !dbg !1096
  %1904 = and i32 %1902, -2147483648, !dbg !1096
  %1905 = icmp eq i32 %1903, %1904, !dbg !1096
  %1906 = and i1 %1900, %1905, !dbg !1096
  %1907 = or i1 %1889, %1906, !dbg !1096
  br i1 %1907, label %1908, label %1910, !dbg !1096

1908:                                             ; preds = %1872
  %1909 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1910, !dbg !1096

1910:                                             ; preds = %1872, %1908
  %1911 = fsub float %1475, %1685, !dbg !1096
  %1912 = bitcast float %1475 to i32, !dbg !1096
  %1913 = and i32 %1912, 2139095040, !dbg !1096
  %is_finite442 = icmp ne i32 %1913, 2139095040, !dbg !1096
  %1914 = and i1 true, %is_finite442, !dbg !1096
  %1915 = bitcast float %1685 to i32, !dbg !1096
  %1916 = and i32 %1915, 2139095040, !dbg !1096
  %is_finite443 = icmp ne i32 %1916, 2139095040, !dbg !1096
  %1917 = and i1 %1914, %is_finite443, !dbg !1096
  %1918 = bitcast float %1911 to i32, !dbg !1096
  %1919 = and i32 %1918, 2139095040, !dbg !1096
  %1920 = icmp eq i32 %1919, 2139095040, !dbg !1096
  %1921 = and i32 %1918, 8388607, !dbg !1096
  %1922 = icmp eq i32 %1921, 0, !dbg !1096
  %is_inf444 = and i1 %1920, %1922, !dbg !1096
  %1923 = bitcast float %1911 to i32, !dbg !1096
  %1924 = and i32 %1923, 2147483647, !dbg !1096
  %is_maxfinite445 = icmp eq i32 %1924, 2139095039, !dbg !1096
  %1925 = bitcast float %1911 to i32, !dbg !1096
  %1926 = and i32 %1925, -2147483648, !dbg !1096
  %1927 = icmp eq i32 %1926, 0, !dbg !1096
  %1928 = icmp ne i32 %1926, 0, !dbg !1096
  %is_pos_inf446 = and i1 %is_inf444, %1927, !dbg !1096
  %is_neg_inf447 = and i1 %is_inf444, %1928, !dbg !1096
  %is_pos_max448 = and i1 %is_maxfinite445, %1927, !dbg !1096
  %is_neg_max449 = and i1 %is_maxfinite445, %1928, !dbg !1096
  %overflow_cond450 = and i1 %1917, %is_inf444, !dbg !1096
  br i1 %overflow_cond450, label %1929, label %1931, !dbg !1096

1929:                                             ; preds = %1910
  %1930 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1931, !dbg !1096

1931:                                             ; preds = %1910, %1929
  %1932 = bitcast float %1475 to i32, !dbg !1096
  %1933 = and i32 %1932, 2139095040, !dbg !1096
  %1934 = icmp eq i32 %1933, 0, !dbg !1096
  %1935 = and i32 %1932, 8388607, !dbg !1096
  %1936 = icmp ne i32 %1935, 0, !dbg !1096
  %is_subnormal451 = and i1 %1934, %1936, !dbg !1096
  %1937 = xor i1 %is_subnormal451, true, !dbg !1096
  %1938 = and i1 true, %1937, !dbg !1096
  %1939 = bitcast float %1685 to i32, !dbg !1096
  %1940 = and i32 %1939, 2139095040, !dbg !1096
  %1941 = icmp eq i32 %1940, 0, !dbg !1096
  %1942 = and i32 %1939, 8388607, !dbg !1096
  %1943 = icmp ne i32 %1942, 0, !dbg !1096
  %is_subnormal452 = and i1 %1941, %1943, !dbg !1096
  %1944 = xor i1 %is_subnormal452, true, !dbg !1096
  %1945 = and i1 %1938, %1944, !dbg !1096
  %1946 = bitcast float %1911 to i32, !dbg !1096
  %1947 = and i32 %1946, 2139095040, !dbg !1096
  %1948 = icmp eq i32 %1947, 0, !dbg !1096
  %1949 = and i32 %1946, 8388607, !dbg !1096
  %1950 = icmp ne i32 %1949, 0, !dbg !1096
  %is_subnormal453 = and i1 %1948, %1950, !dbg !1096
  %subnormal_cond454 = and i1 %1945, %is_subnormal453, !dbg !1096
  br i1 %subnormal_cond454, label %1951, label %1953, !dbg !1096

1951:                                             ; preds = %1931
  %1952 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %1953, !dbg !1096

1953:                                             ; preds = %1931, %1951
  %1954 = bitcast float %1911 to i32, !dbg !1096
  %1955 = bitcast float %1911 to i32, !dbg !1096
  %1956 = and i32 %1955, 2139095040, !dbg !1096
  %1957 = icmp eq i32 %1956, 2139095040, !dbg !1096
  %1958 = and i32 %1955, 8388607, !dbg !1096
  %1959 = icmp ne i32 %1958, 0, !dbg !1096
  %is_nan455 = and i1 %1957, %1959, !dbg !1096
  %1960 = and i32 %1954, 4194304, !dbg !1096
  %1961 = icmp eq i32 %1960, 0, !dbg !1096
  %is_snan456 = and i1 %is_nan455, %1961, !dbg !1096
  %1962 = or i1 false, %is_snan456, !dbg !1096
  %1963 = bitcast float %1911 to i32, !dbg !1096
  %1964 = and i32 %1963, 2139095040, !dbg !1096
  %1965 = icmp eq i32 %1964, 2139095040, !dbg !1096
  %1966 = and i32 %1963, 8388607, !dbg !1096
  %1967 = icmp eq i32 %1966, 0, !dbg !1096
  %is_inf457 = and i1 %1965, %1967, !dbg !1096
  %1968 = and i1 false, %is_inf457, !dbg !1096
  %1969 = bitcast float %1911 to i32, !dbg !1096
  %1970 = and i32 %1969, 2147483647, !dbg !1096
  %is_zero458 = icmp eq i32 %1970, 0, !dbg !1096
  %1971 = and i1 false, %is_zero458, !dbg !1096
  %1972 = or i1 %1968, %1971, !dbg !1096
  %1973 = or i1 %1962, %1972, !dbg !1096
  br i1 %1973, label %1974, label %1976, !dbg !1096

1974:                                             ; preds = %1953
  %1975 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %1976, !dbg !1096

1976:                                             ; preds = %1953, %1974
  %1977 = fmul float 2.000000e+00, %1911, !dbg !1096
  %1978 = bitcast float %1911 to i32, !dbg !1096
  %1979 = and i32 %1978, 2139095040, !dbg !1096
  %is_finite459 = icmp ne i32 %1979, 2139095040, !dbg !1096
  %1980 = and i1 true, %is_finite459, !dbg !1096
  %1981 = bitcast float %1977 to i32, !dbg !1096
  %1982 = and i32 %1981, 2139095040, !dbg !1096
  %1983 = icmp eq i32 %1982, 2139095040, !dbg !1096
  %1984 = and i32 %1981, 8388607, !dbg !1096
  %1985 = icmp eq i32 %1984, 0, !dbg !1096
  %is_inf460 = and i1 %1983, %1985, !dbg !1096
  %1986 = bitcast float %1977 to i32, !dbg !1096
  %1987 = and i32 %1986, 2147483647, !dbg !1096
  %is_maxfinite461 = icmp eq i32 %1987, 2139095039, !dbg !1096
  %1988 = bitcast float %1977 to i32, !dbg !1096
  %1989 = and i32 %1988, -2147483648, !dbg !1096
  %1990 = icmp eq i32 %1989, 0, !dbg !1096
  %1991 = icmp ne i32 %1989, 0, !dbg !1096
  %is_pos_inf462 = and i1 %is_inf460, %1990, !dbg !1096
  %is_neg_inf463 = and i1 %is_inf460, %1991, !dbg !1096
  %is_pos_max464 = and i1 %is_maxfinite461, %1990, !dbg !1096
  %is_neg_max465 = and i1 %is_maxfinite461, %1991, !dbg !1096
  %overflow_cond466 = and i1 %1980, %is_inf460, !dbg !1096
  br i1 %overflow_cond466, label %1992, label %1994, !dbg !1096

1992:                                             ; preds = %1976
  %1993 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %1994, !dbg !1096

1994:                                             ; preds = %1976, %1992
  %1995 = bitcast float %1911 to i32, !dbg !1096
  %1996 = and i32 %1995, 2139095040, !dbg !1096
  %1997 = icmp eq i32 %1996, 0, !dbg !1096
  %1998 = and i32 %1995, 8388607, !dbg !1096
  %1999 = icmp ne i32 %1998, 0, !dbg !1096
  %is_subnormal467 = and i1 %1997, %1999, !dbg !1096
  %2000 = xor i1 %is_subnormal467, true, !dbg !1096
  %2001 = and i1 true, %2000, !dbg !1096
  %2002 = bitcast float %1977 to i32, !dbg !1096
  %2003 = and i32 %2002, 2139095040, !dbg !1096
  %2004 = icmp eq i32 %2003, 0, !dbg !1096
  %2005 = and i32 %2002, 8388607, !dbg !1096
  %2006 = icmp ne i32 %2005, 0, !dbg !1096
  %is_subnormal468 = and i1 %2004, %2006, !dbg !1096
  %2007 = bitcast float %1977 to i32, !dbg !1096
  %2008 = and i32 %2007, 2147483647, !dbg !1096
  %is_zero469 = icmp eq i32 %2008, 0, !dbg !1096
  %2009 = bitcast float %1911 to i32, !dbg !1096
  %2010 = and i32 %2009, 2147483647, !dbg !1096
  %is_zero470 = icmp eq i32 %2010, 0, !dbg !1096
  %2011 = xor i1 %is_zero470, true, !dbg !1096
  %2012 = and i1 true, %2011, !dbg !1096
  %2013 = and i1 %is_zero469, %2012, !dbg !1096
  %is_tiny471 = or i1 %is_subnormal468, %2013, !dbg !1096
  %underflow_cond472 = and i1 %2001, %is_tiny471, !dbg !1096
  br i1 %underflow_cond472, label %2014, label %2016, !dbg !1096

2014:                                             ; preds = %1994
  %2015 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2016, !dbg !1096

2016:                                             ; preds = %1994, %2014
  %2017 = bitcast float %1911 to i32, !dbg !1096
  %2018 = and i32 %2017, 2139095040, !dbg !1096
  %2019 = icmp eq i32 %2018, 0, !dbg !1096
  %2020 = and i32 %2017, 8388607, !dbg !1096
  %2021 = icmp ne i32 %2020, 0, !dbg !1096
  %is_subnormal473 = and i1 %2019, %2021, !dbg !1096
  %2022 = xor i1 %is_subnormal473, true, !dbg !1096
  %2023 = and i1 true, %2022, !dbg !1096
  %2024 = bitcast float %1977 to i32, !dbg !1096
  %2025 = and i32 %2024, 2139095040, !dbg !1096
  %2026 = icmp eq i32 %2025, 0, !dbg !1096
  %2027 = and i32 %2024, 8388607, !dbg !1096
  %2028 = icmp ne i32 %2027, 0, !dbg !1096
  %is_subnormal474 = and i1 %2026, %2028, !dbg !1096
  %subnormal_cond475 = and i1 %2023, %is_subnormal474, !dbg !1096
  br i1 %subnormal_cond475, label %2029, label %2031, !dbg !1096

2029:                                             ; preds = %2016
  %2030 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2031, !dbg !1096

2031:                                             ; preds = %2016, %2029
  %2032 = bitcast float %1685 to i32, !dbg !1096
  %2033 = bitcast float %1685 to i32, !dbg !1096
  %2034 = and i32 %2033, 2139095040, !dbg !1096
  %2035 = icmp eq i32 %2034, 2139095040, !dbg !1096
  %2036 = and i32 %2033, 8388607, !dbg !1096
  %2037 = icmp ne i32 %2036, 0, !dbg !1096
  %is_nan476 = and i1 %2035, %2037, !dbg !1096
  %2038 = and i32 %2032, 4194304, !dbg !1096
  %2039 = icmp eq i32 %2038, 0, !dbg !1096
  %is_snan477 = and i1 %is_nan476, %2039, !dbg !1096
  %2040 = or i1 false, %is_snan477, !dbg !1096
  %2041 = bitcast float %1685 to i32, !dbg !1096
  %2042 = and i32 %2041, 2139095040, !dbg !1096
  %2043 = icmp eq i32 %2042, 2139095040, !dbg !1096
  %2044 = and i32 %2041, 8388607, !dbg !1096
  %2045 = icmp eq i32 %2044, 0, !dbg !1096
  %is_inf478 = and i1 %2043, %2045, !dbg !1096
  %2046 = and i1 false, %is_inf478, !dbg !1096
  %2047 = bitcast float %1685 to i32, !dbg !1096
  %2048 = and i32 %2047, -2147483648, !dbg !1096
  %2049 = icmp eq i32 -2147483648, %2048, !dbg !1096
  %2050 = and i1 %2046, %2049, !dbg !1096
  %2051 = or i1 %2040, %2050, !dbg !1096
  br i1 %2051, label %2052, label %2054, !dbg !1096

2052:                                             ; preds = %2031
  %2053 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2054, !dbg !1096

2054:                                             ; preds = %2031, %2052
  %2055 = fsub float -0.000000e+00, %1685, !dbg !1096
  %2056 = bitcast float %1685 to i32, !dbg !1096
  %2057 = and i32 %2056, 2139095040, !dbg !1096
  %is_finite479 = icmp ne i32 %2057, 2139095040, !dbg !1096
  %2058 = and i1 true, %is_finite479, !dbg !1096
  %2059 = bitcast float %2055 to i32, !dbg !1096
  %2060 = and i32 %2059, 2139095040, !dbg !1096
  %2061 = icmp eq i32 %2060, 2139095040, !dbg !1096
  %2062 = and i32 %2059, 8388607, !dbg !1096
  %2063 = icmp eq i32 %2062, 0, !dbg !1096
  %is_inf480 = and i1 %2061, %2063, !dbg !1096
  %2064 = bitcast float %2055 to i32, !dbg !1096
  %2065 = and i32 %2064, 2147483647, !dbg !1096
  %is_maxfinite481 = icmp eq i32 %2065, 2139095039, !dbg !1096
  %2066 = bitcast float %2055 to i32, !dbg !1096
  %2067 = and i32 %2066, -2147483648, !dbg !1096
  %2068 = icmp eq i32 %2067, 0, !dbg !1096
  %2069 = icmp ne i32 %2067, 0, !dbg !1096
  %is_pos_inf482 = and i1 %is_inf480, %2068, !dbg !1096
  %is_neg_inf483 = and i1 %is_inf480, %2069, !dbg !1096
  %is_pos_max484 = and i1 %is_maxfinite481, %2068, !dbg !1096
  %is_neg_max485 = and i1 %is_maxfinite481, %2069, !dbg !1096
  %overflow_cond486 = and i1 %2058, %is_inf480, !dbg !1096
  br i1 %overflow_cond486, label %2070, label %2072, !dbg !1096

2070:                                             ; preds = %2054
  %2071 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2072, !dbg !1096

2072:                                             ; preds = %2054, %2070
  %2073 = bitcast float %1685 to i32, !dbg !1096
  %2074 = and i32 %2073, 2139095040, !dbg !1096
  %2075 = icmp eq i32 %2074, 0, !dbg !1096
  %2076 = and i32 %2073, 8388607, !dbg !1096
  %2077 = icmp ne i32 %2076, 0, !dbg !1096
  %is_subnormal487 = and i1 %2075, %2077, !dbg !1096
  %2078 = xor i1 %is_subnormal487, true, !dbg !1096
  %2079 = and i1 true, %2078, !dbg !1096
  %2080 = bitcast float %2055 to i32, !dbg !1096
  %2081 = and i32 %2080, 2139095040, !dbg !1096
  %2082 = icmp eq i32 %2081, 0, !dbg !1096
  %2083 = and i32 %2080, 8388607, !dbg !1096
  %2084 = icmp ne i32 %2083, 0, !dbg !1096
  %is_subnormal488 = and i1 %2082, %2084, !dbg !1096
  %subnormal_cond489 = and i1 %2079, %is_subnormal488, !dbg !1096
  br i1 %subnormal_cond489, label %2085, label %2087, !dbg !1096

2085:                                             ; preds = %2072
  %2086 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2087, !dbg !1096

2087:                                             ; preds = %2072, %2085
  %2088 = bitcast float %2055 to i32, !dbg !1096
  %2089 = bitcast float %2055 to i32, !dbg !1096
  %2090 = and i32 %2089, 2139095040, !dbg !1096
  %2091 = icmp eq i32 %2090, 2139095040, !dbg !1096
  %2092 = and i32 %2089, 8388607, !dbg !1096
  %2093 = icmp ne i32 %2092, 0, !dbg !1096
  %is_nan490 = and i1 %2091, %2093, !dbg !1096
  %2094 = and i32 %2088, 4194304, !dbg !1096
  %2095 = icmp eq i32 %2094, 0, !dbg !1096
  %is_snan491 = and i1 %is_nan490, %2095, !dbg !1096
  %2096 = bitcast float %1475 to i32, !dbg !1096
  %2097 = bitcast float %1475 to i32, !dbg !1096
  %2098 = and i32 %2097, 2139095040, !dbg !1096
  %2099 = icmp eq i32 %2098, 2139095040, !dbg !1096
  %2100 = and i32 %2097, 8388607, !dbg !1096
  %2101 = icmp ne i32 %2100, 0, !dbg !1096
  %is_nan492 = and i1 %2099, %2101, !dbg !1096
  %2102 = and i32 %2096, 4194304, !dbg !1096
  %2103 = icmp eq i32 %2102, 0, !dbg !1096
  %is_snan493 = and i1 %is_nan492, %2103, !dbg !1096
  %2104 = or i1 %is_snan491, %is_snan493, !dbg !1096
  %2105 = bitcast float %1977 to i32, !dbg !1096
  %2106 = bitcast float %1977 to i32, !dbg !1096
  %2107 = and i32 %2106, 2139095040, !dbg !1096
  %2108 = icmp eq i32 %2107, 2139095040, !dbg !1096
  %2109 = and i32 %2106, 8388607, !dbg !1096
  %2110 = icmp ne i32 %2109, 0, !dbg !1096
  %is_nan494 = and i1 %2108, %2110, !dbg !1096
  %2111 = and i32 %2105, 4194304, !dbg !1096
  %2112 = icmp eq i32 %2111, 0, !dbg !1096
  %is_snan495 = and i1 %is_nan494, %2112, !dbg !1096
  %2113 = or i1 %2104, %is_snan495, !dbg !1096
  %2114 = bitcast float %2055 to i32, !dbg !1096
  %2115 = and i32 %2114, 2147483647, !dbg !1096
  %is_zero496 = icmp eq i32 %2115, 0, !dbg !1096
  %2116 = bitcast float %1475 to i32, !dbg !1096
  %2117 = and i32 %2116, 2139095040, !dbg !1096
  %2118 = icmp eq i32 %2117, 2139095040, !dbg !1096
  %2119 = and i32 %2116, 8388607, !dbg !1096
  %2120 = icmp eq i32 %2119, 0, !dbg !1096
  %is_inf497 = and i1 %2118, %2120, !dbg !1096
  %2121 = and i1 %is_zero496, %is_inf497, !dbg !1096
  %2122 = bitcast float %2055 to i32, !dbg !1096
  %2123 = and i32 %2122, 2139095040, !dbg !1096
  %2124 = icmp eq i32 %2123, 2139095040, !dbg !1096
  %2125 = and i32 %2122, 8388607, !dbg !1096
  %2126 = icmp eq i32 %2125, 0, !dbg !1096
  %is_inf498 = and i1 %2124, %2126, !dbg !1096
  %2127 = bitcast float %1475 to i32, !dbg !1096
  %2128 = and i32 %2127, 2147483647, !dbg !1096
  %is_zero499 = icmp eq i32 %2128, 0, !dbg !1096
  %2129 = and i1 %is_inf498, %is_zero499, !dbg !1096
  %2130 = or i1 %2121, %2129, !dbg !1096
  %2131 = or i1 %2113, %2130, !dbg !1096
  br i1 %2131, label %2132, label %2134, !dbg !1096

2132:                                             ; preds = %2087
  %2133 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2134, !dbg !1096

2134:                                             ; preds = %2087, %2132
  %2135 = call float @llvm.nvvm.fma.rn.f(float %2055, float %1475, float %1977) #5, !dbg !1096
  %2136 = bitcast float %2055 to i32, !dbg !1096
  %2137 = and i32 %2136, 2139095040, !dbg !1096
  %is_finite500 = icmp ne i32 %2137, 2139095040, !dbg !1096
  %2138 = and i1 true, %is_finite500, !dbg !1096
  %2139 = bitcast float %1475 to i32, !dbg !1096
  %2140 = and i32 %2139, 2139095040, !dbg !1096
  %is_finite501 = icmp ne i32 %2140, 2139095040, !dbg !1096
  %2141 = and i1 %2138, %is_finite501, !dbg !1096
  %2142 = bitcast float %2135 to i32, !dbg !1096
  %2143 = and i32 %2142, 2139095040, !dbg !1096
  %2144 = icmp eq i32 %2143, 2139095040, !dbg !1096
  %2145 = and i32 %2142, 8388607, !dbg !1096
  %2146 = icmp eq i32 %2145, 0, !dbg !1096
  %is_inf502 = and i1 %2144, %2146, !dbg !1096
  %2147 = bitcast float %2135 to i32, !dbg !1096
  %2148 = and i32 %2147, 2147483647, !dbg !1096
  %is_maxfinite503 = icmp eq i32 %2148, 2139095039, !dbg !1096
  %2149 = bitcast float %2135 to i32, !dbg !1096
  %2150 = and i32 %2149, -2147483648, !dbg !1096
  %2151 = icmp eq i32 %2150, 0, !dbg !1096
  %2152 = icmp ne i32 %2150, 0, !dbg !1096
  %is_pos_inf504 = and i1 %is_inf502, %2151, !dbg !1096
  %is_neg_inf505 = and i1 %is_inf502, %2152, !dbg !1096
  %is_pos_max506 = and i1 %is_maxfinite503, %2151, !dbg !1096
  %is_neg_max507 = and i1 %is_maxfinite503, %2152, !dbg !1096
  %overflow_cond508 = and i1 %2141, %is_inf502, !dbg !1096
  br i1 %overflow_cond508, label %2153, label %2155, !dbg !1096

2153:                                             ; preds = %2134
  %2154 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2155, !dbg !1096

2155:                                             ; preds = %2134, %2153
  %2156 = bitcast float %2055 to i32, !dbg !1096
  %2157 = and i32 %2156, 2139095040, !dbg !1096
  %2158 = icmp eq i32 %2157, 0, !dbg !1096
  %2159 = and i32 %2156, 8388607, !dbg !1096
  %2160 = icmp ne i32 %2159, 0, !dbg !1096
  %is_subnormal509 = and i1 %2158, %2160, !dbg !1096
  %2161 = xor i1 %is_subnormal509, true, !dbg !1096
  %2162 = and i1 true, %2161, !dbg !1096
  %2163 = bitcast float %1475 to i32, !dbg !1096
  %2164 = and i32 %2163, 2139095040, !dbg !1096
  %2165 = icmp eq i32 %2164, 0, !dbg !1096
  %2166 = and i32 %2163, 8388607, !dbg !1096
  %2167 = icmp ne i32 %2166, 0, !dbg !1096
  %is_subnormal510 = and i1 %2165, %2167, !dbg !1096
  %2168 = xor i1 %is_subnormal510, true, !dbg !1096
  %2169 = and i1 %2162, %2168, !dbg !1096
  %2170 = bitcast float %1977 to i32, !dbg !1096
  %2171 = and i32 %2170, 2139095040, !dbg !1096
  %2172 = icmp eq i32 %2171, 0, !dbg !1096
  %2173 = and i32 %2170, 8388607, !dbg !1096
  %2174 = icmp ne i32 %2173, 0, !dbg !1096
  %is_subnormal511 = and i1 %2172, %2174, !dbg !1096
  %2175 = xor i1 %is_subnormal511, true, !dbg !1096
  %2176 = and i1 %2169, %2175, !dbg !1096
  %2177 = bitcast float %2135 to i32, !dbg !1096
  %2178 = and i32 %2177, 2139095040, !dbg !1096
  %2179 = icmp eq i32 %2178, 0, !dbg !1096
  %2180 = and i32 %2177, 8388607, !dbg !1096
  %2181 = icmp ne i32 %2180, 0, !dbg !1096
  %is_subnormal512 = and i1 %2179, %2181, !dbg !1096
  %2182 = bitcast float %2135 to i32, !dbg !1096
  %2183 = and i32 %2182, 2147483647, !dbg !1096
  %is_zero513 = icmp eq i32 %2183, 0, !dbg !1096
  %2184 = bitcast float %2055 to i32, !dbg !1096
  %2185 = and i32 %2184, 2147483647, !dbg !1096
  %is_zero514 = icmp eq i32 %2185, 0, !dbg !1096
  %2186 = xor i1 %is_zero514, true, !dbg !1096
  %2187 = bitcast float %1475 to i32, !dbg !1096
  %2188 = and i32 %2187, 2147483647, !dbg !1096
  %is_zero515 = icmp eq i32 %2188, 0, !dbg !1096
  %2189 = xor i1 %is_zero515, true, !dbg !1096
  %2190 = bitcast float %1977 to i32, !dbg !1096
  %2191 = and i32 %2190, 2147483647, !dbg !1096
  %is_zero516 = icmp eq i32 %2191, 0, !dbg !1096
  %2192 = xor i1 %is_zero516, true, !dbg !1096
  %2193 = and i1 %2186, %2189, !dbg !1096
  %2194 = and i1 %2193, %2192, !dbg !1096
  %2195 = and i1 %is_zero513, %2194, !dbg !1096
  %is_tiny517 = or i1 %is_subnormal512, %2195, !dbg !1096
  %underflow_cond518 = and i1 %2176, %is_tiny517, !dbg !1096
  br i1 %underflow_cond518, label %2196, label %2198, !dbg !1096

2196:                                             ; preds = %2155
  %2197 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2198, !dbg !1096

2198:                                             ; preds = %2155, %2196
  %2199 = bitcast float %2055 to i32, !dbg !1096
  %2200 = and i32 %2199, 2139095040, !dbg !1096
  %2201 = icmp eq i32 %2200, 0, !dbg !1096
  %2202 = and i32 %2199, 8388607, !dbg !1096
  %2203 = icmp ne i32 %2202, 0, !dbg !1096
  %is_subnormal519 = and i1 %2201, %2203, !dbg !1096
  %2204 = xor i1 %is_subnormal519, true, !dbg !1096
  %2205 = and i1 true, %2204, !dbg !1096
  %2206 = bitcast float %1475 to i32, !dbg !1096
  %2207 = and i32 %2206, 2139095040, !dbg !1096
  %2208 = icmp eq i32 %2207, 0, !dbg !1096
  %2209 = and i32 %2206, 8388607, !dbg !1096
  %2210 = icmp ne i32 %2209, 0, !dbg !1096
  %is_subnormal520 = and i1 %2208, %2210, !dbg !1096
  %2211 = xor i1 %is_subnormal520, true, !dbg !1096
  %2212 = and i1 %2205, %2211, !dbg !1096
  %2213 = bitcast float %1977 to i32, !dbg !1096
  %2214 = and i32 %2213, 2139095040, !dbg !1096
  %2215 = icmp eq i32 %2214, 0, !dbg !1096
  %2216 = and i32 %2213, 8388607, !dbg !1096
  %2217 = icmp ne i32 %2216, 0, !dbg !1096
  %is_subnormal521 = and i1 %2215, %2217, !dbg !1096
  %2218 = xor i1 %is_subnormal521, true, !dbg !1096
  %2219 = and i1 %2212, %2218, !dbg !1096
  %2220 = bitcast float %2135 to i32, !dbg !1096
  %2221 = and i32 %2220, 2139095040, !dbg !1096
  %2222 = icmp eq i32 %2221, 0, !dbg !1096
  %2223 = and i32 %2220, 8388607, !dbg !1096
  %2224 = icmp ne i32 %2223, 0, !dbg !1096
  %is_subnormal522 = and i1 %2222, %2224, !dbg !1096
  %subnormal_cond523 = and i1 %2219, %is_subnormal522, !dbg !1096
  br i1 %subnormal_cond523, label %2225, label %2227, !dbg !1096

2225:                                             ; preds = %2198
  %2226 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2227, !dbg !1096

2227:                                             ; preds = %2198, %2225
  %2228 = bitcast float %1568 to i32, !dbg !1096
  %2229 = bitcast float %1568 to i32, !dbg !1096
  %2230 = and i32 %2229, 2139095040, !dbg !1096
  %2231 = icmp eq i32 %2230, 2139095040, !dbg !1096
  %2232 = and i32 %2229, 8388607, !dbg !1096
  %2233 = icmp ne i32 %2232, 0, !dbg !1096
  %is_nan524 = and i1 %2231, %2233, !dbg !1096
  %2234 = and i32 %2228, 4194304, !dbg !1096
  %2235 = icmp eq i32 %2234, 0, !dbg !1096
  %is_snan525 = and i1 %is_nan524, %2235, !dbg !1096
  %2236 = bitcast float %2135 to i32, !dbg !1096
  %2237 = bitcast float %2135 to i32, !dbg !1096
  %2238 = and i32 %2237, 2139095040, !dbg !1096
  %2239 = icmp eq i32 %2238, 2139095040, !dbg !1096
  %2240 = and i32 %2237, 8388607, !dbg !1096
  %2241 = icmp ne i32 %2240, 0, !dbg !1096
  %is_nan526 = and i1 %2239, %2241, !dbg !1096
  %2242 = and i32 %2236, 4194304, !dbg !1096
  %2243 = icmp eq i32 %2242, 0, !dbg !1096
  %is_snan527 = and i1 %is_nan526, %2243, !dbg !1096
  %2244 = or i1 %is_snan525, %is_snan527, !dbg !1096
  %2245 = bitcast float %1568 to i32, !dbg !1096
  %2246 = and i32 %2245, 2147483647, !dbg !1096
  %is_zero528 = icmp eq i32 %2246, 0, !dbg !1096
  %2247 = bitcast float %2135 to i32, !dbg !1096
  %2248 = and i32 %2247, 2139095040, !dbg !1096
  %2249 = icmp eq i32 %2248, 2139095040, !dbg !1096
  %2250 = and i32 %2247, 8388607, !dbg !1096
  %2251 = icmp eq i32 %2250, 0, !dbg !1096
  %is_inf529 = and i1 %2249, %2251, !dbg !1096
  %2252 = and i1 %is_zero528, %is_inf529, !dbg !1096
  %2253 = bitcast float %1568 to i32, !dbg !1096
  %2254 = and i32 %2253, 2139095040, !dbg !1096
  %2255 = icmp eq i32 %2254, 2139095040, !dbg !1096
  %2256 = and i32 %2253, 8388607, !dbg !1096
  %2257 = icmp eq i32 %2256, 0, !dbg !1096
  %is_inf530 = and i1 %2255, %2257, !dbg !1096
  %2258 = bitcast float %2135 to i32, !dbg !1096
  %2259 = and i32 %2258, 2147483647, !dbg !1096
  %is_zero531 = icmp eq i32 %2259, 0, !dbg !1096
  %2260 = and i1 %is_inf530, %is_zero531, !dbg !1096
  %2261 = or i1 %2252, %2260, !dbg !1096
  %2262 = or i1 %2244, %2261, !dbg !1096
  br i1 %2262, label %2263, label %2265, !dbg !1096

2263:                                             ; preds = %2227
  %2264 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2265, !dbg !1096

2265:                                             ; preds = %2227, %2263
  %2266 = call float @llvm.nvvm.mul.rn.f(float %1568, float %2135) #5, !dbg !1096
  %2267 = bitcast float %1568 to i32, !dbg !1096
  %2268 = and i32 %2267, 2139095040, !dbg !1096
  %is_finite532 = icmp ne i32 %2268, 2139095040, !dbg !1096
  %2269 = and i1 true, %is_finite532, !dbg !1096
  %2270 = bitcast float %2135 to i32, !dbg !1096
  %2271 = and i32 %2270, 2139095040, !dbg !1096
  %is_finite533 = icmp ne i32 %2271, 2139095040, !dbg !1096
  %2272 = and i1 %2269, %is_finite533, !dbg !1096
  %2273 = bitcast float %2266 to i32, !dbg !1096
  %2274 = and i32 %2273, 2139095040, !dbg !1096
  %2275 = icmp eq i32 %2274, 2139095040, !dbg !1096
  %2276 = and i32 %2273, 8388607, !dbg !1096
  %2277 = icmp eq i32 %2276, 0, !dbg !1096
  %is_inf534 = and i1 %2275, %2277, !dbg !1096
  %2278 = bitcast float %2266 to i32, !dbg !1096
  %2279 = and i32 %2278, 2147483647, !dbg !1096
  %is_maxfinite535 = icmp eq i32 %2279, 2139095039, !dbg !1096
  %2280 = bitcast float %2266 to i32, !dbg !1096
  %2281 = and i32 %2280, -2147483648, !dbg !1096
  %2282 = icmp eq i32 %2281, 0, !dbg !1096
  %2283 = icmp ne i32 %2281, 0, !dbg !1096
  %is_pos_inf536 = and i1 %is_inf534, %2282, !dbg !1096
  %is_neg_inf537 = and i1 %is_inf534, %2283, !dbg !1096
  %is_pos_max538 = and i1 %is_maxfinite535, %2282, !dbg !1096
  %is_neg_max539 = and i1 %is_maxfinite535, %2283, !dbg !1096
  %overflow_cond540 = and i1 %2272, %is_inf534, !dbg !1096
  br i1 %overflow_cond540, label %2284, label %2286, !dbg !1096

2284:                                             ; preds = %2265
  %2285 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2286, !dbg !1096

2286:                                             ; preds = %2265, %2284
  %2287 = bitcast float %1568 to i32, !dbg !1096
  %2288 = and i32 %2287, 2139095040, !dbg !1096
  %2289 = icmp eq i32 %2288, 0, !dbg !1096
  %2290 = and i32 %2287, 8388607, !dbg !1096
  %2291 = icmp ne i32 %2290, 0, !dbg !1096
  %is_subnormal541 = and i1 %2289, %2291, !dbg !1096
  %2292 = xor i1 %is_subnormal541, true, !dbg !1096
  %2293 = and i1 true, %2292, !dbg !1096
  %2294 = bitcast float %2135 to i32, !dbg !1096
  %2295 = and i32 %2294, 2139095040, !dbg !1096
  %2296 = icmp eq i32 %2295, 0, !dbg !1096
  %2297 = and i32 %2294, 8388607, !dbg !1096
  %2298 = icmp ne i32 %2297, 0, !dbg !1096
  %is_subnormal542 = and i1 %2296, %2298, !dbg !1096
  %2299 = xor i1 %is_subnormal542, true, !dbg !1096
  %2300 = and i1 %2293, %2299, !dbg !1096
  %2301 = bitcast float %2266 to i32, !dbg !1096
  %2302 = and i32 %2301, 2139095040, !dbg !1096
  %2303 = icmp eq i32 %2302, 0, !dbg !1096
  %2304 = and i32 %2301, 8388607, !dbg !1096
  %2305 = icmp ne i32 %2304, 0, !dbg !1096
  %is_subnormal543 = and i1 %2303, %2305, !dbg !1096
  %2306 = bitcast float %2266 to i32, !dbg !1096
  %2307 = and i32 %2306, 2147483647, !dbg !1096
  %is_zero544 = icmp eq i32 %2307, 0, !dbg !1096
  %2308 = bitcast float %1568 to i32, !dbg !1096
  %2309 = and i32 %2308, 2147483647, !dbg !1096
  %is_zero545 = icmp eq i32 %2309, 0, !dbg !1096
  %2310 = xor i1 %is_zero545, true, !dbg !1096
  %2311 = bitcast float %2135 to i32, !dbg !1096
  %2312 = and i32 %2311, 2147483647, !dbg !1096
  %is_zero546 = icmp eq i32 %2312, 0, !dbg !1096
  %2313 = xor i1 %is_zero546, true, !dbg !1096
  %2314 = and i1 %2310, %2313, !dbg !1096
  %2315 = and i1 %is_zero544, %2314, !dbg !1096
  %is_tiny547 = or i1 %is_subnormal543, %2315, !dbg !1096
  %underflow_cond548 = and i1 %2300, %is_tiny547, !dbg !1096
  br i1 %underflow_cond548, label %2316, label %2318, !dbg !1096

2316:                                             ; preds = %2286
  %2317 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2318, !dbg !1096

2318:                                             ; preds = %2286, %2316
  %2319 = bitcast float %1568 to i32, !dbg !1096
  %2320 = and i32 %2319, 2139095040, !dbg !1096
  %2321 = icmp eq i32 %2320, 0, !dbg !1096
  %2322 = and i32 %2319, 8388607, !dbg !1096
  %2323 = icmp ne i32 %2322, 0, !dbg !1096
  %is_subnormal549 = and i1 %2321, %2323, !dbg !1096
  %2324 = xor i1 %is_subnormal549, true, !dbg !1096
  %2325 = and i1 true, %2324, !dbg !1096
  %2326 = bitcast float %2135 to i32, !dbg !1096
  %2327 = and i32 %2326, 2139095040, !dbg !1096
  %2328 = icmp eq i32 %2327, 0, !dbg !1096
  %2329 = and i32 %2326, 8388607, !dbg !1096
  %2330 = icmp ne i32 %2329, 0, !dbg !1096
  %is_subnormal550 = and i1 %2328, %2330, !dbg !1096
  %2331 = xor i1 %is_subnormal550, true, !dbg !1096
  %2332 = and i1 %2325, %2331, !dbg !1096
  %2333 = bitcast float %2266 to i32, !dbg !1096
  %2334 = and i32 %2333, 2139095040, !dbg !1096
  %2335 = icmp eq i32 %2334, 0, !dbg !1096
  %2336 = and i32 %2333, 8388607, !dbg !1096
  %2337 = icmp ne i32 %2336, 0, !dbg !1096
  %is_subnormal551 = and i1 %2335, %2337, !dbg !1096
  %subnormal_cond552 = and i1 %2332, %is_subnormal551, !dbg !1096
  br i1 %subnormal_cond552, label %2338, label %2340, !dbg !1096

2338:                                             ; preds = %2318
  %2339 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2340, !dbg !1096

2340:                                             ; preds = %2318, %2338
  %2341 = bitcast float %1798 to i32, !dbg !1096
  %2342 = bitcast float %1798 to i32, !dbg !1096
  %2343 = and i32 %2342, 2139095040, !dbg !1096
  %2344 = icmp eq i32 %2343, 2139095040, !dbg !1096
  %2345 = and i32 %2342, 8388607, !dbg !1096
  %2346 = icmp ne i32 %2345, 0, !dbg !1096
  %is_nan553 = and i1 %2344, %2346, !dbg !1096
  %2347 = and i32 %2341, 4194304, !dbg !1096
  %2348 = icmp eq i32 %2347, 0, !dbg !1096
  %is_snan554 = and i1 %is_nan553, %2348, !dbg !1096
  %2349 = or i1 false, %is_snan554, !dbg !1096
  %2350 = or i1 %2349, false, !dbg !1096
  %2351 = bitcast float %1798 to i32, !dbg !1096
  %2352 = and i32 %2351, 2139095040, !dbg !1096
  %2353 = icmp eq i32 %2352, 2139095040, !dbg !1096
  %2354 = and i32 %2351, 8388607, !dbg !1096
  %2355 = icmp eq i32 %2354, 0, !dbg !1096
  %is_inf555 = and i1 %2353, %2355, !dbg !1096
  %2356 = and i1 false, %is_inf555, !dbg !1096
  %2357 = bitcast float %1798 to i32, !dbg !1096
  %2358 = and i32 %2357, 2147483647, !dbg !1096
  %is_zero556 = icmp eq i32 %2358, 0, !dbg !1096
  %2359 = and i1 false, %is_zero556, !dbg !1096
  %2360 = or i1 %2356, %2359, !dbg !1096
  %2361 = or i1 %2350, %2360, !dbg !1096
  br i1 %2361, label %2362, label %2364, !dbg !1096

2362:                                             ; preds = %2340
  %2363 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2364, !dbg !1096

2364:                                             ; preds = %2340, %2362
  %2365 = call float @llvm.nvvm.fma.rn.f(float 0x3F45865C80000000, float %1798, float 0x3F6A5CFB60000000) #5, !dbg !1096
  %2366 = bitcast float %1798 to i32, !dbg !1096
  %2367 = and i32 %2366, 2139095040, !dbg !1096
  %is_finite557 = icmp ne i32 %2367, 2139095040, !dbg !1096
  %2368 = and i1 true, %is_finite557, !dbg !1096
  %2369 = bitcast float %2365 to i32, !dbg !1096
  %2370 = and i32 %2369, 2139095040, !dbg !1096
  %2371 = icmp eq i32 %2370, 2139095040, !dbg !1096
  %2372 = and i32 %2369, 8388607, !dbg !1096
  %2373 = icmp eq i32 %2372, 0, !dbg !1096
  %is_inf558 = and i1 %2371, %2373, !dbg !1096
  %2374 = bitcast float %2365 to i32, !dbg !1096
  %2375 = and i32 %2374, 2147483647, !dbg !1096
  %is_maxfinite559 = icmp eq i32 %2375, 2139095039, !dbg !1096
  %2376 = bitcast float %2365 to i32, !dbg !1096
  %2377 = and i32 %2376, -2147483648, !dbg !1096
  %2378 = icmp eq i32 %2377, 0, !dbg !1096
  %2379 = icmp ne i32 %2377, 0, !dbg !1096
  %is_pos_inf560 = and i1 %is_inf558, %2378, !dbg !1096
  %is_neg_inf561 = and i1 %is_inf558, %2379, !dbg !1096
  %is_pos_max562 = and i1 %is_maxfinite559, %2378, !dbg !1096
  %is_neg_max563 = and i1 %is_maxfinite559, %2379, !dbg !1096
  %overflow_cond564 = and i1 %2368, %is_inf558, !dbg !1096
  br i1 %overflow_cond564, label %2380, label %2382, !dbg !1096

2380:                                             ; preds = %2364
  %2381 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2382, !dbg !1096

2382:                                             ; preds = %2364, %2380
  %2383 = bitcast float %1798 to i32, !dbg !1096
  %2384 = and i32 %2383, 2139095040, !dbg !1096
  %2385 = icmp eq i32 %2384, 0, !dbg !1096
  %2386 = and i32 %2383, 8388607, !dbg !1096
  %2387 = icmp ne i32 %2386, 0, !dbg !1096
  %is_subnormal565 = and i1 %2385, %2387, !dbg !1096
  %2388 = xor i1 %is_subnormal565, true, !dbg !1096
  %2389 = and i1 true, %2388, !dbg !1096
  %2390 = and i1 %2389, true, !dbg !1096
  %2391 = bitcast float %2365 to i32, !dbg !1096
  %2392 = and i32 %2391, 2139095040, !dbg !1096
  %2393 = icmp eq i32 %2392, 0, !dbg !1096
  %2394 = and i32 %2391, 8388607, !dbg !1096
  %2395 = icmp ne i32 %2394, 0, !dbg !1096
  %is_subnormal566 = and i1 %2393, %2395, !dbg !1096
  %2396 = bitcast float %2365 to i32, !dbg !1096
  %2397 = and i32 %2396, 2147483647, !dbg !1096
  %is_zero567 = icmp eq i32 %2397, 0, !dbg !1096
  %2398 = bitcast float %1798 to i32, !dbg !1096
  %2399 = and i32 %2398, 2147483647, !dbg !1096
  %is_zero568 = icmp eq i32 %2399, 0, !dbg !1096
  %2400 = xor i1 %is_zero568, true, !dbg !1096
  %2401 = and i1 true, %2400, !dbg !1096
  %2402 = and i1 %2401, true, !dbg !1096
  %2403 = and i1 %is_zero567, %2402, !dbg !1096
  %is_tiny569 = or i1 %is_subnormal566, %2403, !dbg !1096
  %underflow_cond570 = and i1 %2390, %is_tiny569, !dbg !1096
  br i1 %underflow_cond570, label %2404, label %2406, !dbg !1096

2404:                                             ; preds = %2382
  %2405 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2406, !dbg !1096

2406:                                             ; preds = %2382, %2404
  %2407 = bitcast float %1798 to i32, !dbg !1096
  %2408 = and i32 %2407, 2139095040, !dbg !1096
  %2409 = icmp eq i32 %2408, 0, !dbg !1096
  %2410 = and i32 %2407, 8388607, !dbg !1096
  %2411 = icmp ne i32 %2410, 0, !dbg !1096
  %is_subnormal571 = and i1 %2409, %2411, !dbg !1096
  %2412 = xor i1 %is_subnormal571, true, !dbg !1096
  %2413 = and i1 true, %2412, !dbg !1096
  %2414 = and i1 %2413, true, !dbg !1096
  %2415 = bitcast float %2365 to i32, !dbg !1096
  %2416 = and i32 %2415, 2139095040, !dbg !1096
  %2417 = icmp eq i32 %2416, 0, !dbg !1096
  %2418 = and i32 %2415, 8388607, !dbg !1096
  %2419 = icmp ne i32 %2418, 0, !dbg !1096
  %is_subnormal572 = and i1 %2417, %2419, !dbg !1096
  %subnormal_cond573 = and i1 %2414, %is_subnormal572, !dbg !1096
  br i1 %subnormal_cond573, label %2420, label %2422, !dbg !1096

2420:                                             ; preds = %2406
  %2421 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2422, !dbg !1096

2422:                                             ; preds = %2406, %2420
  %2423 = bitcast float %2365 to i32, !dbg !1096
  %2424 = bitcast float %2365 to i32, !dbg !1096
  %2425 = and i32 %2424, 2139095040, !dbg !1096
  %2426 = icmp eq i32 %2425, 2139095040, !dbg !1096
  %2427 = and i32 %2424, 8388607, !dbg !1096
  %2428 = icmp ne i32 %2427, 0, !dbg !1096
  %is_nan574 = and i1 %2426, %2428, !dbg !1096
  %2429 = and i32 %2423, 4194304, !dbg !1096
  %2430 = icmp eq i32 %2429, 0, !dbg !1096
  %is_snan575 = and i1 %is_nan574, %2430, !dbg !1096
  %2431 = bitcast float %1798 to i32, !dbg !1096
  %2432 = bitcast float %1798 to i32, !dbg !1096
  %2433 = and i32 %2432, 2139095040, !dbg !1096
  %2434 = icmp eq i32 %2433, 2139095040, !dbg !1096
  %2435 = and i32 %2432, 8388607, !dbg !1096
  %2436 = icmp ne i32 %2435, 0, !dbg !1096
  %is_nan576 = and i1 %2434, %2436, !dbg !1096
  %2437 = and i32 %2431, 4194304, !dbg !1096
  %2438 = icmp eq i32 %2437, 0, !dbg !1096
  %is_snan577 = and i1 %is_nan576, %2438, !dbg !1096
  %2439 = or i1 %is_snan575, %is_snan577, !dbg !1096
  %2440 = or i1 %2439, false, !dbg !1096
  %2441 = bitcast float %2365 to i32, !dbg !1096
  %2442 = and i32 %2441, 2147483647, !dbg !1096
  %is_zero578 = icmp eq i32 %2442, 0, !dbg !1096
  %2443 = bitcast float %1798 to i32, !dbg !1096
  %2444 = and i32 %2443, 2139095040, !dbg !1096
  %2445 = icmp eq i32 %2444, 2139095040, !dbg !1096
  %2446 = and i32 %2443, 8388607, !dbg !1096
  %2447 = icmp eq i32 %2446, 0, !dbg !1096
  %is_inf579 = and i1 %2445, %2447, !dbg !1096
  %2448 = and i1 %is_zero578, %is_inf579, !dbg !1096
  %2449 = bitcast float %2365 to i32, !dbg !1096
  %2450 = and i32 %2449, 2139095040, !dbg !1096
  %2451 = icmp eq i32 %2450, 2139095040, !dbg !1096
  %2452 = and i32 %2449, 8388607, !dbg !1096
  %2453 = icmp eq i32 %2452, 0, !dbg !1096
  %is_inf580 = and i1 %2451, %2453, !dbg !1096
  %2454 = bitcast float %1798 to i32, !dbg !1096
  %2455 = and i32 %2454, 2147483647, !dbg !1096
  %is_zero581 = icmp eq i32 %2455, 0, !dbg !1096
  %2456 = and i1 %is_inf580, %is_zero581, !dbg !1096
  %2457 = or i1 %2448, %2456, !dbg !1096
  %2458 = or i1 %2440, %2457, !dbg !1096
  br i1 %2458, label %2459, label %2461, !dbg !1096

2459:                                             ; preds = %2422
  %2460 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2461, !dbg !1096

2461:                                             ; preds = %2422, %2459
  %2462 = call float @llvm.nvvm.fma.rn.f(float %2365, float %1798, float 0x3F92776E60000000) #5, !dbg !1096
  %2463 = bitcast float %2365 to i32, !dbg !1096
  %2464 = and i32 %2463, 2139095040, !dbg !1096
  %is_finite582 = icmp ne i32 %2464, 2139095040, !dbg !1096
  %2465 = and i1 true, %is_finite582, !dbg !1096
  %2466 = bitcast float %1798 to i32, !dbg !1096
  %2467 = and i32 %2466, 2139095040, !dbg !1096
  %is_finite583 = icmp ne i32 %2467, 2139095040, !dbg !1096
  %2468 = and i1 %2465, %is_finite583, !dbg !1096
  %2469 = bitcast float %2462 to i32, !dbg !1096
  %2470 = and i32 %2469, 2139095040, !dbg !1096
  %2471 = icmp eq i32 %2470, 2139095040, !dbg !1096
  %2472 = and i32 %2469, 8388607, !dbg !1096
  %2473 = icmp eq i32 %2472, 0, !dbg !1096
  %is_inf584 = and i1 %2471, %2473, !dbg !1096
  %2474 = bitcast float %2462 to i32, !dbg !1096
  %2475 = and i32 %2474, 2147483647, !dbg !1096
  %is_maxfinite585 = icmp eq i32 %2475, 2139095039, !dbg !1096
  %2476 = bitcast float %2462 to i32, !dbg !1096
  %2477 = and i32 %2476, -2147483648, !dbg !1096
  %2478 = icmp eq i32 %2477, 0, !dbg !1096
  %2479 = icmp ne i32 %2477, 0, !dbg !1096
  %is_pos_inf586 = and i1 %is_inf584, %2478, !dbg !1096
  %is_neg_inf587 = and i1 %is_inf584, %2479, !dbg !1096
  %is_pos_max588 = and i1 %is_maxfinite585, %2478, !dbg !1096
  %is_neg_max589 = and i1 %is_maxfinite585, %2479, !dbg !1096
  %overflow_cond590 = and i1 %2468, %is_inf584, !dbg !1096
  br i1 %overflow_cond590, label %2480, label %2482, !dbg !1096

2480:                                             ; preds = %2461
  %2481 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2482, !dbg !1096

2482:                                             ; preds = %2461, %2480
  %2483 = bitcast float %2365 to i32, !dbg !1096
  %2484 = and i32 %2483, 2139095040, !dbg !1096
  %2485 = icmp eq i32 %2484, 0, !dbg !1096
  %2486 = and i32 %2483, 8388607, !dbg !1096
  %2487 = icmp ne i32 %2486, 0, !dbg !1096
  %is_subnormal591 = and i1 %2485, %2487, !dbg !1096
  %2488 = xor i1 %is_subnormal591, true, !dbg !1096
  %2489 = and i1 true, %2488, !dbg !1096
  %2490 = bitcast float %1798 to i32, !dbg !1096
  %2491 = and i32 %2490, 2139095040, !dbg !1096
  %2492 = icmp eq i32 %2491, 0, !dbg !1096
  %2493 = and i32 %2490, 8388607, !dbg !1096
  %2494 = icmp ne i32 %2493, 0, !dbg !1096
  %is_subnormal592 = and i1 %2492, %2494, !dbg !1096
  %2495 = xor i1 %is_subnormal592, true, !dbg !1096
  %2496 = and i1 %2489, %2495, !dbg !1096
  %2497 = and i1 %2496, true, !dbg !1096
  %2498 = bitcast float %2462 to i32, !dbg !1096
  %2499 = and i32 %2498, 2139095040, !dbg !1096
  %2500 = icmp eq i32 %2499, 0, !dbg !1096
  %2501 = and i32 %2498, 8388607, !dbg !1096
  %2502 = icmp ne i32 %2501, 0, !dbg !1096
  %is_subnormal593 = and i1 %2500, %2502, !dbg !1096
  %2503 = bitcast float %2462 to i32, !dbg !1096
  %2504 = and i32 %2503, 2147483647, !dbg !1096
  %is_zero594 = icmp eq i32 %2504, 0, !dbg !1096
  %2505 = bitcast float %2365 to i32, !dbg !1096
  %2506 = and i32 %2505, 2147483647, !dbg !1096
  %is_zero595 = icmp eq i32 %2506, 0, !dbg !1096
  %2507 = xor i1 %is_zero595, true, !dbg !1096
  %2508 = bitcast float %1798 to i32, !dbg !1096
  %2509 = and i32 %2508, 2147483647, !dbg !1096
  %is_zero596 = icmp eq i32 %2509, 0, !dbg !1096
  %2510 = xor i1 %is_zero596, true, !dbg !1096
  %2511 = and i1 %2507, %2510, !dbg !1096
  %2512 = and i1 %2511, true, !dbg !1096
  %2513 = and i1 %is_zero594, %2512, !dbg !1096
  %is_tiny597 = or i1 %is_subnormal593, %2513, !dbg !1096
  %underflow_cond598 = and i1 %2497, %is_tiny597, !dbg !1096
  br i1 %underflow_cond598, label %2514, label %2516, !dbg !1096

2514:                                             ; preds = %2482
  %2515 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2516, !dbg !1096

2516:                                             ; preds = %2482, %2514
  %2517 = bitcast float %2365 to i32, !dbg !1096
  %2518 = and i32 %2517, 2139095040, !dbg !1096
  %2519 = icmp eq i32 %2518, 0, !dbg !1096
  %2520 = and i32 %2517, 8388607, !dbg !1096
  %2521 = icmp ne i32 %2520, 0, !dbg !1096
  %is_subnormal599 = and i1 %2519, %2521, !dbg !1096
  %2522 = xor i1 %is_subnormal599, true, !dbg !1096
  %2523 = and i1 true, %2522, !dbg !1096
  %2524 = bitcast float %1798 to i32, !dbg !1096
  %2525 = and i32 %2524, 2139095040, !dbg !1096
  %2526 = icmp eq i32 %2525, 0, !dbg !1096
  %2527 = and i32 %2524, 8388607, !dbg !1096
  %2528 = icmp ne i32 %2527, 0, !dbg !1096
  %is_subnormal600 = and i1 %2526, %2528, !dbg !1096
  %2529 = xor i1 %is_subnormal600, true, !dbg !1096
  %2530 = and i1 %2523, %2529, !dbg !1096
  %2531 = and i1 %2530, true, !dbg !1096
  %2532 = bitcast float %2462 to i32, !dbg !1096
  %2533 = and i32 %2532, 2139095040, !dbg !1096
  %2534 = icmp eq i32 %2533, 0, !dbg !1096
  %2535 = and i32 %2532, 8388607, !dbg !1096
  %2536 = icmp ne i32 %2535, 0, !dbg !1096
  %is_subnormal601 = and i1 %2534, %2536, !dbg !1096
  %subnormal_cond602 = and i1 %2531, %is_subnormal601, !dbg !1096
  br i1 %subnormal_cond602, label %2537, label %2539, !dbg !1096

2537:                                             ; preds = %2516
  %2538 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2539, !dbg !1096

2539:                                             ; preds = %2516, %2537
  %2540 = bitcast float %2462 to i32, !dbg !1096
  %2541 = bitcast float %2462 to i32, !dbg !1096
  %2542 = and i32 %2541, 2139095040, !dbg !1096
  %2543 = icmp eq i32 %2542, 2139095040, !dbg !1096
  %2544 = and i32 %2541, 8388607, !dbg !1096
  %2545 = icmp ne i32 %2544, 0, !dbg !1096
  %is_nan603 = and i1 %2543, %2545, !dbg !1096
  %2546 = and i32 %2540, 4194304, !dbg !1096
  %2547 = icmp eq i32 %2546, 0, !dbg !1096
  %is_snan604 = and i1 %is_nan603, %2547, !dbg !1096
  %2548 = bitcast float %1798 to i32, !dbg !1096
  %2549 = bitcast float %1798 to i32, !dbg !1096
  %2550 = and i32 %2549, 2139095040, !dbg !1096
  %2551 = icmp eq i32 %2550, 2139095040, !dbg !1096
  %2552 = and i32 %2549, 8388607, !dbg !1096
  %2553 = icmp ne i32 %2552, 0, !dbg !1096
  %is_nan605 = and i1 %2551, %2553, !dbg !1096
  %2554 = and i32 %2548, 4194304, !dbg !1096
  %2555 = icmp eq i32 %2554, 0, !dbg !1096
  %is_snan606 = and i1 %is_nan605, %2555, !dbg !1096
  %2556 = or i1 %is_snan604, %is_snan606, !dbg !1096
  %2557 = or i1 %2556, false, !dbg !1096
  %2558 = bitcast float %2462 to i32, !dbg !1096
  %2559 = and i32 %2558, 2147483647, !dbg !1096
  %is_zero607 = icmp eq i32 %2559, 0, !dbg !1096
  %2560 = bitcast float %1798 to i32, !dbg !1096
  %2561 = and i32 %2560, 2139095040, !dbg !1096
  %2562 = icmp eq i32 %2561, 2139095040, !dbg !1096
  %2563 = and i32 %2560, 8388607, !dbg !1096
  %2564 = icmp eq i32 %2563, 0, !dbg !1096
  %is_inf608 = and i1 %2562, %2564, !dbg !1096
  %2565 = and i1 %is_zero607, %is_inf608, !dbg !1096
  %2566 = bitcast float %2462 to i32, !dbg !1096
  %2567 = and i32 %2566, 2139095040, !dbg !1096
  %2568 = icmp eq i32 %2567, 2139095040, !dbg !1096
  %2569 = and i32 %2566, 8388607, !dbg !1096
  %2570 = icmp eq i32 %2569, 0, !dbg !1096
  %is_inf609 = and i1 %2568, %2570, !dbg !1096
  %2571 = bitcast float %1798 to i32, !dbg !1096
  %2572 = and i32 %2571, 2147483647, !dbg !1096
  %is_zero610 = icmp eq i32 %2572, 0, !dbg !1096
  %2573 = and i1 %is_inf609, %is_zero610, !dbg !1096
  %2574 = or i1 %2565, %2573, !dbg !1096
  %2575 = or i1 %2557, %2574, !dbg !1096
  br i1 %2575, label %2576, label %2578, !dbg !1096

2576:                                             ; preds = %2539
  %2577 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2578, !dbg !1096

2578:                                             ; preds = %2539, %2576
  %2579 = call float @llvm.nvvm.fma.rn.f(float %2462, float %1798, float 0x3FBEC709E0000000) #5, !dbg !1096
  %2580 = bitcast float %2462 to i32, !dbg !1096
  %2581 = and i32 %2580, 2139095040, !dbg !1096
  %is_finite611 = icmp ne i32 %2581, 2139095040, !dbg !1096
  %2582 = and i1 true, %is_finite611, !dbg !1096
  %2583 = bitcast float %1798 to i32, !dbg !1096
  %2584 = and i32 %2583, 2139095040, !dbg !1096
  %is_finite612 = icmp ne i32 %2584, 2139095040, !dbg !1096
  %2585 = and i1 %2582, %is_finite612, !dbg !1096
  %2586 = bitcast float %2579 to i32, !dbg !1096
  %2587 = and i32 %2586, 2139095040, !dbg !1096
  %2588 = icmp eq i32 %2587, 2139095040, !dbg !1096
  %2589 = and i32 %2586, 8388607, !dbg !1096
  %2590 = icmp eq i32 %2589, 0, !dbg !1096
  %is_inf613 = and i1 %2588, %2590, !dbg !1096
  %2591 = bitcast float %2579 to i32, !dbg !1096
  %2592 = and i32 %2591, 2147483647, !dbg !1096
  %is_maxfinite614 = icmp eq i32 %2592, 2139095039, !dbg !1096
  %2593 = bitcast float %2579 to i32, !dbg !1096
  %2594 = and i32 %2593, -2147483648, !dbg !1096
  %2595 = icmp eq i32 %2594, 0, !dbg !1096
  %2596 = icmp ne i32 %2594, 0, !dbg !1096
  %is_pos_inf615 = and i1 %is_inf613, %2595, !dbg !1096
  %is_neg_inf616 = and i1 %is_inf613, %2596, !dbg !1096
  %is_pos_max617 = and i1 %is_maxfinite614, %2595, !dbg !1096
  %is_neg_max618 = and i1 %is_maxfinite614, %2596, !dbg !1096
  %overflow_cond619 = and i1 %2585, %is_inf613, !dbg !1096
  br i1 %overflow_cond619, label %2597, label %2599, !dbg !1096

2597:                                             ; preds = %2578
  %2598 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2599, !dbg !1096

2599:                                             ; preds = %2578, %2597
  %2600 = bitcast float %2462 to i32, !dbg !1096
  %2601 = and i32 %2600, 2139095040, !dbg !1096
  %2602 = icmp eq i32 %2601, 0, !dbg !1096
  %2603 = and i32 %2600, 8388607, !dbg !1096
  %2604 = icmp ne i32 %2603, 0, !dbg !1096
  %is_subnormal620 = and i1 %2602, %2604, !dbg !1096
  %2605 = xor i1 %is_subnormal620, true, !dbg !1096
  %2606 = and i1 true, %2605, !dbg !1096
  %2607 = bitcast float %1798 to i32, !dbg !1096
  %2608 = and i32 %2607, 2139095040, !dbg !1096
  %2609 = icmp eq i32 %2608, 0, !dbg !1096
  %2610 = and i32 %2607, 8388607, !dbg !1096
  %2611 = icmp ne i32 %2610, 0, !dbg !1096
  %is_subnormal621 = and i1 %2609, %2611, !dbg !1096
  %2612 = xor i1 %is_subnormal621, true, !dbg !1096
  %2613 = and i1 %2606, %2612, !dbg !1096
  %2614 = and i1 %2613, true, !dbg !1096
  %2615 = bitcast float %2579 to i32, !dbg !1096
  %2616 = and i32 %2615, 2139095040, !dbg !1096
  %2617 = icmp eq i32 %2616, 0, !dbg !1096
  %2618 = and i32 %2615, 8388607, !dbg !1096
  %2619 = icmp ne i32 %2618, 0, !dbg !1096
  %is_subnormal622 = and i1 %2617, %2619, !dbg !1096
  %2620 = bitcast float %2579 to i32, !dbg !1096
  %2621 = and i32 %2620, 2147483647, !dbg !1096
  %is_zero623 = icmp eq i32 %2621, 0, !dbg !1096
  %2622 = bitcast float %2462 to i32, !dbg !1096
  %2623 = and i32 %2622, 2147483647, !dbg !1096
  %is_zero624 = icmp eq i32 %2623, 0, !dbg !1096
  %2624 = xor i1 %is_zero624, true, !dbg !1096
  %2625 = bitcast float %1798 to i32, !dbg !1096
  %2626 = and i32 %2625, 2147483647, !dbg !1096
  %is_zero625 = icmp eq i32 %2626, 0, !dbg !1096
  %2627 = xor i1 %is_zero625, true, !dbg !1096
  %2628 = and i1 %2624, %2627, !dbg !1096
  %2629 = and i1 %2628, true, !dbg !1096
  %2630 = and i1 %is_zero623, %2629, !dbg !1096
  %is_tiny626 = or i1 %is_subnormal622, %2630, !dbg !1096
  %underflow_cond627 = and i1 %2614, %is_tiny626, !dbg !1096
  br i1 %underflow_cond627, label %2631, label %2633, !dbg !1096

2631:                                             ; preds = %2599
  %2632 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2633, !dbg !1096

2633:                                             ; preds = %2599, %2631
  %2634 = bitcast float %2462 to i32, !dbg !1096
  %2635 = and i32 %2634, 2139095040, !dbg !1096
  %2636 = icmp eq i32 %2635, 0, !dbg !1096
  %2637 = and i32 %2634, 8388607, !dbg !1096
  %2638 = icmp ne i32 %2637, 0, !dbg !1096
  %is_subnormal628 = and i1 %2636, %2638, !dbg !1096
  %2639 = xor i1 %is_subnormal628, true, !dbg !1096
  %2640 = and i1 true, %2639, !dbg !1096
  %2641 = bitcast float %1798 to i32, !dbg !1096
  %2642 = and i32 %2641, 2139095040, !dbg !1096
  %2643 = icmp eq i32 %2642, 0, !dbg !1096
  %2644 = and i32 %2641, 8388607, !dbg !1096
  %2645 = icmp ne i32 %2644, 0, !dbg !1096
  %is_subnormal629 = and i1 %2643, %2645, !dbg !1096
  %2646 = xor i1 %is_subnormal629, true, !dbg !1096
  %2647 = and i1 %2640, %2646, !dbg !1096
  %2648 = and i1 %2647, true, !dbg !1096
  %2649 = bitcast float %2579 to i32, !dbg !1096
  %2650 = and i32 %2649, 2139095040, !dbg !1096
  %2651 = icmp eq i32 %2650, 0, !dbg !1096
  %2652 = and i32 %2649, 8388607, !dbg !1096
  %2653 = icmp ne i32 %2652, 0, !dbg !1096
  %is_subnormal630 = and i1 %2651, %2653, !dbg !1096
  %subnormal_cond631 = and i1 %2648, %is_subnormal630, !dbg !1096
  br i1 %subnormal_cond631, label %2654, label %2656, !dbg !1096

2654:                                             ; preds = %2633
  %2655 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2656, !dbg !1096

2656:                                             ; preds = %2633, %2654
  %2657 = bitcast float %2579 to i32, !dbg !1096
  %2658 = bitcast float %2579 to i32, !dbg !1096
  %2659 = and i32 %2658, 2139095040, !dbg !1096
  %2660 = icmp eq i32 %2659, 2139095040, !dbg !1096
  %2661 = and i32 %2658, 8388607, !dbg !1096
  %2662 = icmp ne i32 %2661, 0, !dbg !1096
  %is_nan632 = and i1 %2660, %2662, !dbg !1096
  %2663 = and i32 %2657, 4194304, !dbg !1096
  %2664 = icmp eq i32 %2663, 0, !dbg !1096
  %is_snan633 = and i1 %is_nan632, %2664, !dbg !1096
  %2665 = bitcast float %1798 to i32, !dbg !1096
  %2666 = bitcast float %1798 to i32, !dbg !1096
  %2667 = and i32 %2666, 2139095040, !dbg !1096
  %2668 = icmp eq i32 %2667, 2139095040, !dbg !1096
  %2669 = and i32 %2666, 8388607, !dbg !1096
  %2670 = icmp ne i32 %2669, 0, !dbg !1096
  %is_nan634 = and i1 %2668, %2670, !dbg !1096
  %2671 = and i32 %2665, 4194304, !dbg !1096
  %2672 = icmp eq i32 %2671, 0, !dbg !1096
  %is_snan635 = and i1 %is_nan634, %2672, !dbg !1096
  %2673 = or i1 %is_snan633, %is_snan635, !dbg !1096
  %2674 = bitcast float %2579 to i32, !dbg !1096
  %2675 = and i32 %2674, 2147483647, !dbg !1096
  %is_zero636 = icmp eq i32 %2675, 0, !dbg !1096
  %2676 = bitcast float %1798 to i32, !dbg !1096
  %2677 = and i32 %2676, 2139095040, !dbg !1096
  %2678 = icmp eq i32 %2677, 2139095040, !dbg !1096
  %2679 = and i32 %2676, 8388607, !dbg !1096
  %2680 = icmp eq i32 %2679, 0, !dbg !1096
  %is_inf637 = and i1 %2678, %2680, !dbg !1096
  %2681 = and i1 %is_zero636, %is_inf637, !dbg !1096
  %2682 = bitcast float %2579 to i32, !dbg !1096
  %2683 = and i32 %2682, 2139095040, !dbg !1096
  %2684 = icmp eq i32 %2683, 2139095040, !dbg !1096
  %2685 = and i32 %2682, 8388607, !dbg !1096
  %2686 = icmp eq i32 %2685, 0, !dbg !1096
  %is_inf638 = and i1 %2684, %2686, !dbg !1096
  %2687 = bitcast float %1798 to i32, !dbg !1096
  %2688 = and i32 %2687, 2147483647, !dbg !1096
  %is_zero639 = icmp eq i32 %2688, 0, !dbg !1096
  %2689 = and i1 %is_inf638, %is_zero639, !dbg !1096
  %2690 = or i1 %2681, %2689, !dbg !1096
  %2691 = or i1 %2673, %2690, !dbg !1096
  br i1 %2691, label %2692, label %2694, !dbg !1096

2692:                                             ; preds = %2656
  %2693 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2694, !dbg !1096

2694:                                             ; preds = %2656, %2692
  %2695 = call float @llvm.nvvm.mul.rn.f(float %2579, float %1798) #5, !dbg !1096
  %2696 = bitcast float %2579 to i32, !dbg !1096
  %2697 = and i32 %2696, 2139095040, !dbg !1096
  %is_finite640 = icmp ne i32 %2697, 2139095040, !dbg !1096
  %2698 = and i1 true, %is_finite640, !dbg !1096
  %2699 = bitcast float %1798 to i32, !dbg !1096
  %2700 = and i32 %2699, 2139095040, !dbg !1096
  %is_finite641 = icmp ne i32 %2700, 2139095040, !dbg !1096
  %2701 = and i1 %2698, %is_finite641, !dbg !1096
  %2702 = bitcast float %2695 to i32, !dbg !1096
  %2703 = and i32 %2702, 2139095040, !dbg !1096
  %2704 = icmp eq i32 %2703, 2139095040, !dbg !1096
  %2705 = and i32 %2702, 8388607, !dbg !1096
  %2706 = icmp eq i32 %2705, 0, !dbg !1096
  %is_inf642 = and i1 %2704, %2706, !dbg !1096
  %2707 = bitcast float %2695 to i32, !dbg !1096
  %2708 = and i32 %2707, 2147483647, !dbg !1096
  %is_maxfinite643 = icmp eq i32 %2708, 2139095039, !dbg !1096
  %2709 = bitcast float %2695 to i32, !dbg !1096
  %2710 = and i32 %2709, -2147483648, !dbg !1096
  %2711 = icmp eq i32 %2710, 0, !dbg !1096
  %2712 = icmp ne i32 %2710, 0, !dbg !1096
  %is_pos_inf644 = and i1 %is_inf642, %2711, !dbg !1096
  %is_neg_inf645 = and i1 %is_inf642, %2712, !dbg !1096
  %is_pos_max646 = and i1 %is_maxfinite643, %2711, !dbg !1096
  %is_neg_max647 = and i1 %is_maxfinite643, %2712, !dbg !1096
  %overflow_cond648 = and i1 %2701, %is_inf642, !dbg !1096
  br i1 %overflow_cond648, label %2713, label %2715, !dbg !1096

2713:                                             ; preds = %2694
  %2714 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2715, !dbg !1096

2715:                                             ; preds = %2694, %2713
  %2716 = bitcast float %2579 to i32, !dbg !1096
  %2717 = and i32 %2716, 2139095040, !dbg !1096
  %2718 = icmp eq i32 %2717, 0, !dbg !1096
  %2719 = and i32 %2716, 8388607, !dbg !1096
  %2720 = icmp ne i32 %2719, 0, !dbg !1096
  %is_subnormal649 = and i1 %2718, %2720, !dbg !1096
  %2721 = xor i1 %is_subnormal649, true, !dbg !1096
  %2722 = and i1 true, %2721, !dbg !1096
  %2723 = bitcast float %1798 to i32, !dbg !1096
  %2724 = and i32 %2723, 2139095040, !dbg !1096
  %2725 = icmp eq i32 %2724, 0, !dbg !1096
  %2726 = and i32 %2723, 8388607, !dbg !1096
  %2727 = icmp ne i32 %2726, 0, !dbg !1096
  %is_subnormal650 = and i1 %2725, %2727, !dbg !1096
  %2728 = xor i1 %is_subnormal650, true, !dbg !1096
  %2729 = and i1 %2722, %2728, !dbg !1096
  %2730 = bitcast float %2695 to i32, !dbg !1096
  %2731 = and i32 %2730, 2139095040, !dbg !1096
  %2732 = icmp eq i32 %2731, 0, !dbg !1096
  %2733 = and i32 %2730, 8388607, !dbg !1096
  %2734 = icmp ne i32 %2733, 0, !dbg !1096
  %is_subnormal651 = and i1 %2732, %2734, !dbg !1096
  %2735 = bitcast float %2695 to i32, !dbg !1096
  %2736 = and i32 %2735, 2147483647, !dbg !1096
  %is_zero652 = icmp eq i32 %2736, 0, !dbg !1096
  %2737 = bitcast float %2579 to i32, !dbg !1096
  %2738 = and i32 %2737, 2147483647, !dbg !1096
  %is_zero653 = icmp eq i32 %2738, 0, !dbg !1096
  %2739 = xor i1 %is_zero653, true, !dbg !1096
  %2740 = bitcast float %1798 to i32, !dbg !1096
  %2741 = and i32 %2740, 2147483647, !dbg !1096
  %is_zero654 = icmp eq i32 %2741, 0, !dbg !1096
  %2742 = xor i1 %is_zero654, true, !dbg !1096
  %2743 = and i1 %2739, %2742, !dbg !1096
  %2744 = and i1 %is_zero652, %2743, !dbg !1096
  %is_tiny655 = or i1 %is_subnormal651, %2744, !dbg !1096
  %underflow_cond656 = and i1 %2729, %is_tiny655, !dbg !1096
  br i1 %underflow_cond656, label %2745, label %2747, !dbg !1096

2745:                                             ; preds = %2715
  %2746 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2747, !dbg !1096

2747:                                             ; preds = %2715, %2745
  %2748 = bitcast float %2579 to i32, !dbg !1096
  %2749 = and i32 %2748, 2139095040, !dbg !1096
  %2750 = icmp eq i32 %2749, 0, !dbg !1096
  %2751 = and i32 %2748, 8388607, !dbg !1096
  %2752 = icmp ne i32 %2751, 0, !dbg !1096
  %is_subnormal657 = and i1 %2750, %2752, !dbg !1096
  %2753 = xor i1 %is_subnormal657, true, !dbg !1096
  %2754 = and i1 true, %2753, !dbg !1096
  %2755 = bitcast float %1798 to i32, !dbg !1096
  %2756 = and i32 %2755, 2139095040, !dbg !1096
  %2757 = icmp eq i32 %2756, 0, !dbg !1096
  %2758 = and i32 %2755, 8388607, !dbg !1096
  %2759 = icmp ne i32 %2758, 0, !dbg !1096
  %is_subnormal658 = and i1 %2757, %2759, !dbg !1096
  %2760 = xor i1 %is_subnormal658, true, !dbg !1096
  %2761 = and i1 %2754, %2760, !dbg !1096
  %2762 = bitcast float %2695 to i32, !dbg !1096
  %2763 = and i32 %2762, 2139095040, !dbg !1096
  %2764 = icmp eq i32 %2763, 0, !dbg !1096
  %2765 = and i32 %2762, 8388607, !dbg !1096
  %2766 = icmp ne i32 %2765, 0, !dbg !1096
  %is_subnormal659 = and i1 %2764, %2766, !dbg !1096
  %subnormal_cond660 = and i1 %2761, %is_subnormal659, !dbg !1096
  br i1 %subnormal_cond660, label %2767, label %2769, !dbg !1096

2767:                                             ; preds = %2747
  %2768 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2769, !dbg !1096

2769:                                             ; preds = %2747, %2767
  %2770 = bitcast float %1685 to i32, !dbg !1096
  %2771 = bitcast float %1685 to i32, !dbg !1096
  %2772 = and i32 %2771, 2139095040, !dbg !1096
  %2773 = icmp eq i32 %2772, 2139095040, !dbg !1096
  %2774 = and i32 %2771, 8388607, !dbg !1096
  %2775 = icmp ne i32 %2774, 0, !dbg !1096
  %is_nan661 = and i1 %2773, %2775, !dbg !1096
  %2776 = and i32 %2770, 4194304, !dbg !1096
  %2777 = icmp eq i32 %2776, 0, !dbg !1096
  %is_snan662 = and i1 %is_nan661, %2777, !dbg !1096
  %2778 = or i1 %is_snan662, false, !dbg !1096
  %2779 = bitcast float %1376 to i32, !dbg !1096
  %2780 = bitcast float %1376 to i32, !dbg !1096
  %2781 = and i32 %2780, 2139095040, !dbg !1096
  %2782 = icmp eq i32 %2781, 2139095040, !dbg !1096
  %2783 = and i32 %2780, 8388607, !dbg !1096
  %2784 = icmp ne i32 %2783, 0, !dbg !1096
  %is_nan663 = and i1 %2782, %2784, !dbg !1096
  %2785 = and i32 %2779, 4194304, !dbg !1096
  %2786 = icmp eq i32 %2785, 0, !dbg !1096
  %is_snan664 = and i1 %is_nan663, %2786, !dbg !1096
  %2787 = or i1 %2778, %is_snan664, !dbg !1096
  %2788 = bitcast float %1685 to i32, !dbg !1096
  %2789 = and i32 %2788, 2147483647, !dbg !1096
  %is_zero665 = icmp eq i32 %2789, 0, !dbg !1096
  %2790 = and i1 %is_zero665, false, !dbg !1096
  %2791 = bitcast float %1685 to i32, !dbg !1096
  %2792 = and i32 %2791, 2139095040, !dbg !1096
  %2793 = icmp eq i32 %2792, 2139095040, !dbg !1096
  %2794 = and i32 %2791, 8388607, !dbg !1096
  %2795 = icmp eq i32 %2794, 0, !dbg !1096
  %is_inf666 = and i1 %2793, %2795, !dbg !1096
  %2796 = and i1 %is_inf666, false, !dbg !1096
  %2797 = or i1 %2790, %2796, !dbg !1096
  %2798 = or i1 %2787, %2797, !dbg !1096
  br i1 %2798, label %2799, label %2801, !dbg !1096

2799:                                             ; preds = %2769
  %2800 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2801, !dbg !1096

2801:                                             ; preds = %2769, %2799
  %2802 = call float @llvm.nvvm.fma.rn.f(float %1685, float 0x3FF7154760000000, float %1376) #5, !dbg !1096
  %2803 = bitcast float %1685 to i32, !dbg !1096
  %2804 = and i32 %2803, 2139095040, !dbg !1096
  %is_finite667 = icmp ne i32 %2804, 2139095040, !dbg !1096
  %2805 = and i1 true, %is_finite667, !dbg !1096
  %2806 = and i1 %2805, true, !dbg !1096
  %2807 = bitcast float %2802 to i32, !dbg !1096
  %2808 = and i32 %2807, 2139095040, !dbg !1096
  %2809 = icmp eq i32 %2808, 2139095040, !dbg !1096
  %2810 = and i32 %2807, 8388607, !dbg !1096
  %2811 = icmp eq i32 %2810, 0, !dbg !1096
  %is_inf668 = and i1 %2809, %2811, !dbg !1096
  %2812 = bitcast float %2802 to i32, !dbg !1096
  %2813 = and i32 %2812, 2147483647, !dbg !1096
  %is_maxfinite669 = icmp eq i32 %2813, 2139095039, !dbg !1096
  %2814 = bitcast float %2802 to i32, !dbg !1096
  %2815 = and i32 %2814, -2147483648, !dbg !1096
  %2816 = icmp eq i32 %2815, 0, !dbg !1096
  %2817 = icmp ne i32 %2815, 0, !dbg !1096
  %is_pos_inf670 = and i1 %is_inf668, %2816, !dbg !1096
  %is_neg_inf671 = and i1 %is_inf668, %2817, !dbg !1096
  %is_pos_max672 = and i1 %is_maxfinite669, %2816, !dbg !1096
  %is_neg_max673 = and i1 %is_maxfinite669, %2817, !dbg !1096
  %overflow_cond674 = and i1 %2806, %is_inf668, !dbg !1096
  br i1 %overflow_cond674, label %2818, label %2820, !dbg !1096

2818:                                             ; preds = %2801
  %2819 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2820, !dbg !1096

2820:                                             ; preds = %2801, %2818
  %2821 = bitcast float %1685 to i32, !dbg !1096
  %2822 = and i32 %2821, 2139095040, !dbg !1096
  %2823 = icmp eq i32 %2822, 0, !dbg !1096
  %2824 = and i32 %2821, 8388607, !dbg !1096
  %2825 = icmp ne i32 %2824, 0, !dbg !1096
  %is_subnormal675 = and i1 %2823, %2825, !dbg !1096
  %2826 = xor i1 %is_subnormal675, true, !dbg !1096
  %2827 = and i1 true, %2826, !dbg !1096
  %2828 = and i1 %2827, true, !dbg !1096
  %2829 = bitcast float %1376 to i32, !dbg !1096
  %2830 = and i32 %2829, 2139095040, !dbg !1096
  %2831 = icmp eq i32 %2830, 0, !dbg !1096
  %2832 = and i32 %2829, 8388607, !dbg !1096
  %2833 = icmp ne i32 %2832, 0, !dbg !1096
  %is_subnormal676 = and i1 %2831, %2833, !dbg !1096
  %2834 = xor i1 %is_subnormal676, true, !dbg !1096
  %2835 = and i1 %2828, %2834, !dbg !1096
  %2836 = bitcast float %2802 to i32, !dbg !1096
  %2837 = and i32 %2836, 2139095040, !dbg !1096
  %2838 = icmp eq i32 %2837, 0, !dbg !1096
  %2839 = and i32 %2836, 8388607, !dbg !1096
  %2840 = icmp ne i32 %2839, 0, !dbg !1096
  %is_subnormal677 = and i1 %2838, %2840, !dbg !1096
  %2841 = bitcast float %2802 to i32, !dbg !1096
  %2842 = and i32 %2841, 2147483647, !dbg !1096
  %is_zero678 = icmp eq i32 %2842, 0, !dbg !1096
  %2843 = bitcast float %1685 to i32, !dbg !1096
  %2844 = and i32 %2843, 2147483647, !dbg !1096
  %is_zero679 = icmp eq i32 %2844, 0, !dbg !1096
  %2845 = xor i1 %is_zero679, true, !dbg !1096
  %2846 = bitcast float %1376 to i32, !dbg !1096
  %2847 = and i32 %2846, 2147483647, !dbg !1096
  %is_zero680 = icmp eq i32 %2847, 0, !dbg !1096
  %2848 = xor i1 %is_zero680, true, !dbg !1096
  %2849 = and i1 %2845, true, !dbg !1096
  %2850 = and i1 %2849, %2848, !dbg !1096
  %2851 = and i1 %is_zero678, %2850, !dbg !1096
  %is_tiny681 = or i1 %is_subnormal677, %2851, !dbg !1096
  %underflow_cond682 = and i1 %2835, %is_tiny681, !dbg !1096
  br i1 %underflow_cond682, label %2852, label %2854, !dbg !1096

2852:                                             ; preds = %2820
  %2853 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %2854, !dbg !1096

2854:                                             ; preds = %2820, %2852
  %2855 = bitcast float %1685 to i32, !dbg !1096
  %2856 = and i32 %2855, 2139095040, !dbg !1096
  %2857 = icmp eq i32 %2856, 0, !dbg !1096
  %2858 = and i32 %2855, 8388607, !dbg !1096
  %2859 = icmp ne i32 %2858, 0, !dbg !1096
  %is_subnormal683 = and i1 %2857, %2859, !dbg !1096
  %2860 = xor i1 %is_subnormal683, true, !dbg !1096
  %2861 = and i1 true, %2860, !dbg !1096
  %2862 = and i1 %2861, true, !dbg !1096
  %2863 = bitcast float %1376 to i32, !dbg !1096
  %2864 = and i32 %2863, 2139095040, !dbg !1096
  %2865 = icmp eq i32 %2864, 0, !dbg !1096
  %2866 = and i32 %2863, 8388607, !dbg !1096
  %2867 = icmp ne i32 %2866, 0, !dbg !1096
  %is_subnormal684 = and i1 %2865, %2867, !dbg !1096
  %2868 = xor i1 %is_subnormal684, true, !dbg !1096
  %2869 = and i1 %2862, %2868, !dbg !1096
  %2870 = bitcast float %2802 to i32, !dbg !1096
  %2871 = and i32 %2870, 2139095040, !dbg !1096
  %2872 = icmp eq i32 %2871, 0, !dbg !1096
  %2873 = and i32 %2870, 8388607, !dbg !1096
  %2874 = icmp ne i32 %2873, 0, !dbg !1096
  %is_subnormal685 = and i1 %2872, %2874, !dbg !1096
  %subnormal_cond686 = and i1 %2869, %is_subnormal685, !dbg !1096
  br i1 %subnormal_cond686, label %2875, label %2877, !dbg !1096

2875:                                             ; preds = %2854
  %2876 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2877, !dbg !1096

2877:                                             ; preds = %2854, %2875
  %2878 = bitcast float %1376 to i32, !dbg !1096
  %2879 = bitcast float %1376 to i32, !dbg !1096
  %2880 = and i32 %2879, 2139095040, !dbg !1096
  %2881 = icmp eq i32 %2880, 2139095040, !dbg !1096
  %2882 = and i32 %2879, 8388607, !dbg !1096
  %2883 = icmp ne i32 %2882, 0, !dbg !1096
  %is_nan687 = and i1 %2881, %2883, !dbg !1096
  %2884 = and i32 %2878, 4194304, !dbg !1096
  %2885 = icmp eq i32 %2884, 0, !dbg !1096
  %is_snan688 = and i1 %is_nan687, %2885, !dbg !1096
  %2886 = bitcast float %2802 to i32, !dbg !1096
  %2887 = bitcast float %2802 to i32, !dbg !1096
  %2888 = and i32 %2887, 2139095040, !dbg !1096
  %2889 = icmp eq i32 %2888, 2139095040, !dbg !1096
  %2890 = and i32 %2887, 8388607, !dbg !1096
  %2891 = icmp ne i32 %2890, 0, !dbg !1096
  %is_nan689 = and i1 %2889, %2891, !dbg !1096
  %2892 = and i32 %2886, 4194304, !dbg !1096
  %2893 = icmp eq i32 %2892, 0, !dbg !1096
  %is_snan690 = and i1 %is_nan689, %2893, !dbg !1096
  %2894 = or i1 %is_snan688, %is_snan690, !dbg !1096
  %2895 = bitcast float %1376 to i32, !dbg !1096
  %2896 = and i32 %2895, 2139095040, !dbg !1096
  %2897 = icmp eq i32 %2896, 2139095040, !dbg !1096
  %2898 = and i32 %2895, 8388607, !dbg !1096
  %2899 = icmp eq i32 %2898, 0, !dbg !1096
  %is_inf691 = and i1 %2897, %2899, !dbg !1096
  %2900 = bitcast float %2802 to i32, !dbg !1096
  %2901 = and i32 %2900, 2139095040, !dbg !1096
  %2902 = icmp eq i32 %2901, 2139095040, !dbg !1096
  %2903 = and i32 %2900, 8388607, !dbg !1096
  %2904 = icmp eq i32 %2903, 0, !dbg !1096
  %is_inf692 = and i1 %2902, %2904, !dbg !1096
  %2905 = and i1 %is_inf691, %is_inf692, !dbg !1096
  %2906 = bitcast float %1376 to i32, !dbg !1096
  %2907 = bitcast float %2802 to i32, !dbg !1096
  %2908 = and i32 %2906, -2147483648, !dbg !1096
  %2909 = and i32 %2907, -2147483648, !dbg !1096
  %2910 = icmp eq i32 %2908, %2909, !dbg !1096
  %2911 = and i1 %2905, %2910, !dbg !1096
  %2912 = or i1 %2894, %2911, !dbg !1096
  br i1 %2912, label %2913, label %2915, !dbg !1096

2913:                                             ; preds = %2877
  %2914 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2915, !dbg !1096

2915:                                             ; preds = %2877, %2913
  %2916 = fsub float %1376, %2802, !dbg !1096
  %2917 = bitcast float %1376 to i32, !dbg !1096
  %2918 = and i32 %2917, 2139095040, !dbg !1096
  %is_finite693 = icmp ne i32 %2918, 2139095040, !dbg !1096
  %2919 = and i1 true, %is_finite693, !dbg !1096
  %2920 = bitcast float %2802 to i32, !dbg !1096
  %2921 = and i32 %2920, 2139095040, !dbg !1096
  %is_finite694 = icmp ne i32 %2921, 2139095040, !dbg !1096
  %2922 = and i1 %2919, %is_finite694, !dbg !1096
  %2923 = bitcast float %2916 to i32, !dbg !1096
  %2924 = and i32 %2923, 2139095040, !dbg !1096
  %2925 = icmp eq i32 %2924, 2139095040, !dbg !1096
  %2926 = and i32 %2923, 8388607, !dbg !1096
  %2927 = icmp eq i32 %2926, 0, !dbg !1096
  %is_inf695 = and i1 %2925, %2927, !dbg !1096
  %2928 = bitcast float %2916 to i32, !dbg !1096
  %2929 = and i32 %2928, 2147483647, !dbg !1096
  %is_maxfinite696 = icmp eq i32 %2929, 2139095039, !dbg !1096
  %2930 = bitcast float %2916 to i32, !dbg !1096
  %2931 = and i32 %2930, -2147483648, !dbg !1096
  %2932 = icmp eq i32 %2931, 0, !dbg !1096
  %2933 = icmp ne i32 %2931, 0, !dbg !1096
  %is_pos_inf697 = and i1 %is_inf695, %2932, !dbg !1096
  %is_neg_inf698 = and i1 %is_inf695, %2933, !dbg !1096
  %is_pos_max699 = and i1 %is_maxfinite696, %2932, !dbg !1096
  %is_neg_max700 = and i1 %is_maxfinite696, %2933, !dbg !1096
  %overflow_cond701 = and i1 %2922, %is_inf695, !dbg !1096
  br i1 %overflow_cond701, label %2934, label %2936, !dbg !1096

2934:                                             ; preds = %2915
  %2935 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %2936, !dbg !1096

2936:                                             ; preds = %2915, %2934
  %2937 = bitcast float %1376 to i32, !dbg !1096
  %2938 = and i32 %2937, 2139095040, !dbg !1096
  %2939 = icmp eq i32 %2938, 0, !dbg !1096
  %2940 = and i32 %2937, 8388607, !dbg !1096
  %2941 = icmp ne i32 %2940, 0, !dbg !1096
  %is_subnormal702 = and i1 %2939, %2941, !dbg !1096
  %2942 = xor i1 %is_subnormal702, true, !dbg !1096
  %2943 = and i1 true, %2942, !dbg !1096
  %2944 = bitcast float %2802 to i32, !dbg !1096
  %2945 = and i32 %2944, 2139095040, !dbg !1096
  %2946 = icmp eq i32 %2945, 0, !dbg !1096
  %2947 = and i32 %2944, 8388607, !dbg !1096
  %2948 = icmp ne i32 %2947, 0, !dbg !1096
  %is_subnormal703 = and i1 %2946, %2948, !dbg !1096
  %2949 = xor i1 %is_subnormal703, true, !dbg !1096
  %2950 = and i1 %2943, %2949, !dbg !1096
  %2951 = bitcast float %2916 to i32, !dbg !1096
  %2952 = and i32 %2951, 2139095040, !dbg !1096
  %2953 = icmp eq i32 %2952, 0, !dbg !1096
  %2954 = and i32 %2951, 8388607, !dbg !1096
  %2955 = icmp ne i32 %2954, 0, !dbg !1096
  %is_subnormal704 = and i1 %2953, %2955, !dbg !1096
  %subnormal_cond705 = and i1 %2950, %is_subnormal704, !dbg !1096
  br i1 %subnormal_cond705, label %2956, label %2958, !dbg !1096

2956:                                             ; preds = %2936
  %2957 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %2958, !dbg !1096

2958:                                             ; preds = %2936, %2956
  %2959 = bitcast float %1685 to i32, !dbg !1096
  %2960 = bitcast float %1685 to i32, !dbg !1096
  %2961 = and i32 %2960, 2139095040, !dbg !1096
  %2962 = icmp eq i32 %2961, 2139095040, !dbg !1096
  %2963 = and i32 %2960, 8388607, !dbg !1096
  %2964 = icmp ne i32 %2963, 0, !dbg !1096
  %is_nan706 = and i1 %2962, %2964, !dbg !1096
  %2965 = and i32 %2959, 4194304, !dbg !1096
  %2966 = icmp eq i32 %2965, 0, !dbg !1096
  %is_snan707 = and i1 %is_nan706, %2966, !dbg !1096
  %2967 = or i1 %is_snan707, false, !dbg !1096
  %2968 = bitcast float %2916 to i32, !dbg !1096
  %2969 = bitcast float %2916 to i32, !dbg !1096
  %2970 = and i32 %2969, 2139095040, !dbg !1096
  %2971 = icmp eq i32 %2970, 2139095040, !dbg !1096
  %2972 = and i32 %2969, 8388607, !dbg !1096
  %2973 = icmp ne i32 %2972, 0, !dbg !1096
  %is_nan708 = and i1 %2971, %2973, !dbg !1096
  %2974 = and i32 %2968, 4194304, !dbg !1096
  %2975 = icmp eq i32 %2974, 0, !dbg !1096
  %is_snan709 = and i1 %is_nan708, %2975, !dbg !1096
  %2976 = or i1 %2967, %is_snan709, !dbg !1096
  %2977 = bitcast float %1685 to i32, !dbg !1096
  %2978 = and i32 %2977, 2147483647, !dbg !1096
  %is_zero710 = icmp eq i32 %2978, 0, !dbg !1096
  %2979 = and i1 %is_zero710, false, !dbg !1096
  %2980 = bitcast float %1685 to i32, !dbg !1096
  %2981 = and i32 %2980, 2139095040, !dbg !1096
  %2982 = icmp eq i32 %2981, 2139095040, !dbg !1096
  %2983 = and i32 %2980, 8388607, !dbg !1096
  %2984 = icmp eq i32 %2983, 0, !dbg !1096
  %is_inf711 = and i1 %2982, %2984, !dbg !1096
  %2985 = and i1 %is_inf711, false, !dbg !1096
  %2986 = or i1 %2979, %2985, !dbg !1096
  %2987 = or i1 %2976, %2986, !dbg !1096
  br i1 %2987, label %2988, label %2990, !dbg !1096

2988:                                             ; preds = %2958
  %2989 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %2990, !dbg !1096

2990:                                             ; preds = %2958, %2988
  %2991 = call float @llvm.nvvm.fma.rn.f(float %1685, float 0x3FF7154760000000, float %2916) #5, !dbg !1096
  %2992 = bitcast float %1685 to i32, !dbg !1096
  %2993 = and i32 %2992, 2139095040, !dbg !1096
  %is_finite712 = icmp ne i32 %2993, 2139095040, !dbg !1096
  %2994 = and i1 true, %is_finite712, !dbg !1096
  %2995 = and i1 %2994, true, !dbg !1096
  %2996 = bitcast float %2991 to i32, !dbg !1096
  %2997 = and i32 %2996, 2139095040, !dbg !1096
  %2998 = icmp eq i32 %2997, 2139095040, !dbg !1096
  %2999 = and i32 %2996, 8388607, !dbg !1096
  %3000 = icmp eq i32 %2999, 0, !dbg !1096
  %is_inf713 = and i1 %2998, %3000, !dbg !1096
  %3001 = bitcast float %2991 to i32, !dbg !1096
  %3002 = and i32 %3001, 2147483647, !dbg !1096
  %is_maxfinite714 = icmp eq i32 %3002, 2139095039, !dbg !1096
  %3003 = bitcast float %2991 to i32, !dbg !1096
  %3004 = and i32 %3003, -2147483648, !dbg !1096
  %3005 = icmp eq i32 %3004, 0, !dbg !1096
  %3006 = icmp ne i32 %3004, 0, !dbg !1096
  %is_pos_inf715 = and i1 %is_inf713, %3005, !dbg !1096
  %is_neg_inf716 = and i1 %is_inf713, %3006, !dbg !1096
  %is_pos_max717 = and i1 %is_maxfinite714, %3005, !dbg !1096
  %is_neg_max718 = and i1 %is_maxfinite714, %3006, !dbg !1096
  %overflow_cond719 = and i1 %2995, %is_inf713, !dbg !1096
  br i1 %overflow_cond719, label %3007, label %3009, !dbg !1096

3007:                                             ; preds = %2990
  %3008 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3009, !dbg !1096

3009:                                             ; preds = %2990, %3007
  %3010 = bitcast float %1685 to i32, !dbg !1096
  %3011 = and i32 %3010, 2139095040, !dbg !1096
  %3012 = icmp eq i32 %3011, 0, !dbg !1096
  %3013 = and i32 %3010, 8388607, !dbg !1096
  %3014 = icmp ne i32 %3013, 0, !dbg !1096
  %is_subnormal720 = and i1 %3012, %3014, !dbg !1096
  %3015 = xor i1 %is_subnormal720, true, !dbg !1096
  %3016 = and i1 true, %3015, !dbg !1096
  %3017 = and i1 %3016, true, !dbg !1096
  %3018 = bitcast float %2916 to i32, !dbg !1096
  %3019 = and i32 %3018, 2139095040, !dbg !1096
  %3020 = icmp eq i32 %3019, 0, !dbg !1096
  %3021 = and i32 %3018, 8388607, !dbg !1096
  %3022 = icmp ne i32 %3021, 0, !dbg !1096
  %is_subnormal721 = and i1 %3020, %3022, !dbg !1096
  %3023 = xor i1 %is_subnormal721, true, !dbg !1096
  %3024 = and i1 %3017, %3023, !dbg !1096
  %3025 = bitcast float %2991 to i32, !dbg !1096
  %3026 = and i32 %3025, 2139095040, !dbg !1096
  %3027 = icmp eq i32 %3026, 0, !dbg !1096
  %3028 = and i32 %3025, 8388607, !dbg !1096
  %3029 = icmp ne i32 %3028, 0, !dbg !1096
  %is_subnormal722 = and i1 %3027, %3029, !dbg !1096
  %3030 = bitcast float %2991 to i32, !dbg !1096
  %3031 = and i32 %3030, 2147483647, !dbg !1096
  %is_zero723 = icmp eq i32 %3031, 0, !dbg !1096
  %3032 = bitcast float %1685 to i32, !dbg !1096
  %3033 = and i32 %3032, 2147483647, !dbg !1096
  %is_zero724 = icmp eq i32 %3033, 0, !dbg !1096
  %3034 = xor i1 %is_zero724, true, !dbg !1096
  %3035 = bitcast float %2916 to i32, !dbg !1096
  %3036 = and i32 %3035, 2147483647, !dbg !1096
  %is_zero725 = icmp eq i32 %3036, 0, !dbg !1096
  %3037 = xor i1 %is_zero725, true, !dbg !1096
  %3038 = and i1 %3034, true, !dbg !1096
  %3039 = and i1 %3038, %3037, !dbg !1096
  %3040 = and i1 %is_zero723, %3039, !dbg !1096
  %is_tiny726 = or i1 %is_subnormal722, %3040, !dbg !1096
  %underflow_cond727 = and i1 %3024, %is_tiny726, !dbg !1096
  br i1 %underflow_cond727, label %3041, label %3043, !dbg !1096

3041:                                             ; preds = %3009
  %3042 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3043, !dbg !1096

3043:                                             ; preds = %3009, %3041
  %3044 = bitcast float %1685 to i32, !dbg !1096
  %3045 = and i32 %3044, 2139095040, !dbg !1096
  %3046 = icmp eq i32 %3045, 0, !dbg !1096
  %3047 = and i32 %3044, 8388607, !dbg !1096
  %3048 = icmp ne i32 %3047, 0, !dbg !1096
  %is_subnormal728 = and i1 %3046, %3048, !dbg !1096
  %3049 = xor i1 %is_subnormal728, true, !dbg !1096
  %3050 = and i1 true, %3049, !dbg !1096
  %3051 = and i1 %3050, true, !dbg !1096
  %3052 = bitcast float %2916 to i32, !dbg !1096
  %3053 = and i32 %3052, 2139095040, !dbg !1096
  %3054 = icmp eq i32 %3053, 0, !dbg !1096
  %3055 = and i32 %3052, 8388607, !dbg !1096
  %3056 = icmp ne i32 %3055, 0, !dbg !1096
  %is_subnormal729 = and i1 %3054, %3056, !dbg !1096
  %3057 = xor i1 %is_subnormal729, true, !dbg !1096
  %3058 = and i1 %3051, %3057, !dbg !1096
  %3059 = bitcast float %2991 to i32, !dbg !1096
  %3060 = and i32 %3059, 2139095040, !dbg !1096
  %3061 = icmp eq i32 %3060, 0, !dbg !1096
  %3062 = and i32 %3059, 8388607, !dbg !1096
  %3063 = icmp ne i32 %3062, 0, !dbg !1096
  %is_subnormal730 = and i1 %3061, %3063, !dbg !1096
  %subnormal_cond731 = and i1 %3058, %is_subnormal730, !dbg !1096
  br i1 %subnormal_cond731, label %3064, label %3066, !dbg !1096

3064:                                             ; preds = %3043
  %3065 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3066, !dbg !1096

3066:                                             ; preds = %3043, %3064
  %insert87.i = insertvalue %struct.float2 undef, float %2802, 0, !dbg !1096
  %insert89.i = insertvalue %struct.float2 %insert87.i, float %2991, 1, !dbg !1096
  %3067 = bitcast float %2266 to i32, !dbg !1096
  %3068 = bitcast float %2266 to i32, !dbg !1096
  %3069 = and i32 %3068, 2139095040, !dbg !1096
  %3070 = icmp eq i32 %3069, 2139095040, !dbg !1096
  %3071 = and i32 %3068, 8388607, !dbg !1096
  %3072 = icmp ne i32 %3071, 0, !dbg !1096
  %is_nan732 = and i1 %3070, %3072, !dbg !1096
  %3073 = and i32 %3067, 4194304, !dbg !1096
  %3074 = icmp eq i32 %3073, 0, !dbg !1096
  %is_snan733 = and i1 %is_nan732, %3074, !dbg !1096
  %3075 = or i1 %is_snan733, false, !dbg !1096
  %3076 = bitcast float %2991 to i32, !dbg !1096
  %3077 = bitcast float %2991 to i32, !dbg !1096
  %3078 = and i32 %3077, 2139095040, !dbg !1096
  %3079 = icmp eq i32 %3078, 2139095040, !dbg !1096
  %3080 = and i32 %3077, 8388607, !dbg !1096
  %3081 = icmp ne i32 %3080, 0, !dbg !1096
  %is_nan734 = and i1 %3079, %3081, !dbg !1096
  %3082 = and i32 %3076, 4194304, !dbg !1096
  %3083 = icmp eq i32 %3082, 0, !dbg !1096
  %is_snan735 = and i1 %is_nan734, %3083, !dbg !1096
  %3084 = or i1 %3075, %is_snan735, !dbg !1096
  %3085 = bitcast float %2266 to i32, !dbg !1096
  %3086 = and i32 %3085, 2147483647, !dbg !1096
  %is_zero736 = icmp eq i32 %3086, 0, !dbg !1096
  %3087 = and i1 %is_zero736, false, !dbg !1096
  %3088 = bitcast float %2266 to i32, !dbg !1096
  %3089 = and i32 %3088, 2139095040, !dbg !1096
  %3090 = icmp eq i32 %3089, 2139095040, !dbg !1096
  %3091 = and i32 %3088, 8388607, !dbg !1096
  %3092 = icmp eq i32 %3091, 0, !dbg !1096
  %is_inf737 = and i1 %3090, %3092, !dbg !1096
  %3093 = and i1 %is_inf737, false, !dbg !1096
  %3094 = or i1 %3087, %3093, !dbg !1096
  %3095 = or i1 %3084, %3094, !dbg !1096
  br i1 %3095, label %3096, label %3098, !dbg !1096

3096:                                             ; preds = %3066
  %3097 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3098, !dbg !1096

3098:                                             ; preds = %3066, %3096
  %3099 = call float @llvm.nvvm.fma.rn.f(float %2266, float 0x3FF7154760000000, float %2991) #5, !dbg !1096
  %3100 = bitcast float %2266 to i32, !dbg !1096
  %3101 = and i32 %3100, 2139095040, !dbg !1096
  %is_finite738 = icmp ne i32 %3101, 2139095040, !dbg !1096
  %3102 = and i1 true, %is_finite738, !dbg !1096
  %3103 = and i1 %3102, true, !dbg !1096
  %3104 = bitcast float %3099 to i32, !dbg !1096
  %3105 = and i32 %3104, 2139095040, !dbg !1096
  %3106 = icmp eq i32 %3105, 2139095040, !dbg !1096
  %3107 = and i32 %3104, 8388607, !dbg !1096
  %3108 = icmp eq i32 %3107, 0, !dbg !1096
  %is_inf739 = and i1 %3106, %3108, !dbg !1096
  %3109 = bitcast float %3099 to i32, !dbg !1096
  %3110 = and i32 %3109, 2147483647, !dbg !1096
  %is_maxfinite740 = icmp eq i32 %3110, 2139095039, !dbg !1096
  %3111 = bitcast float %3099 to i32, !dbg !1096
  %3112 = and i32 %3111, -2147483648, !dbg !1096
  %3113 = icmp eq i32 %3112, 0, !dbg !1096
  %3114 = icmp ne i32 %3112, 0, !dbg !1096
  %is_pos_inf741 = and i1 %is_inf739, %3113, !dbg !1096
  %is_neg_inf742 = and i1 %is_inf739, %3114, !dbg !1096
  %is_pos_max743 = and i1 %is_maxfinite740, %3113, !dbg !1096
  %is_neg_max744 = and i1 %is_maxfinite740, %3114, !dbg !1096
  %overflow_cond745 = and i1 %3103, %is_inf739, !dbg !1096
  br i1 %overflow_cond745, label %3115, label %3117, !dbg !1096

3115:                                             ; preds = %3098
  %3116 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3117, !dbg !1096

3117:                                             ; preds = %3098, %3115
  %3118 = bitcast float %2266 to i32, !dbg !1096
  %3119 = and i32 %3118, 2139095040, !dbg !1096
  %3120 = icmp eq i32 %3119, 0, !dbg !1096
  %3121 = and i32 %3118, 8388607, !dbg !1096
  %3122 = icmp ne i32 %3121, 0, !dbg !1096
  %is_subnormal746 = and i1 %3120, %3122, !dbg !1096
  %3123 = xor i1 %is_subnormal746, true, !dbg !1096
  %3124 = and i1 true, %3123, !dbg !1096
  %3125 = and i1 %3124, true, !dbg !1096
  %3126 = bitcast float %2991 to i32, !dbg !1096
  %3127 = and i32 %3126, 2139095040, !dbg !1096
  %3128 = icmp eq i32 %3127, 0, !dbg !1096
  %3129 = and i32 %3126, 8388607, !dbg !1096
  %3130 = icmp ne i32 %3129, 0, !dbg !1096
  %is_subnormal747 = and i1 %3128, %3130, !dbg !1096
  %3131 = xor i1 %is_subnormal747, true, !dbg !1096
  %3132 = and i1 %3125, %3131, !dbg !1096
  %3133 = bitcast float %3099 to i32, !dbg !1096
  %3134 = and i32 %3133, 2139095040, !dbg !1096
  %3135 = icmp eq i32 %3134, 0, !dbg !1096
  %3136 = and i32 %3133, 8388607, !dbg !1096
  %3137 = icmp ne i32 %3136, 0, !dbg !1096
  %is_subnormal748 = and i1 %3135, %3137, !dbg !1096
  %3138 = bitcast float %3099 to i32, !dbg !1096
  %3139 = and i32 %3138, 2147483647, !dbg !1096
  %is_zero749 = icmp eq i32 %3139, 0, !dbg !1096
  %3140 = bitcast float %2266 to i32, !dbg !1096
  %3141 = and i32 %3140, 2147483647, !dbg !1096
  %is_zero750 = icmp eq i32 %3141, 0, !dbg !1096
  %3142 = xor i1 %is_zero750, true, !dbg !1096
  %3143 = bitcast float %2991 to i32, !dbg !1096
  %3144 = and i32 %3143, 2147483647, !dbg !1096
  %is_zero751 = icmp eq i32 %3144, 0, !dbg !1096
  %3145 = xor i1 %is_zero751, true, !dbg !1096
  %3146 = and i1 %3142, true, !dbg !1096
  %3147 = and i1 %3146, %3145, !dbg !1096
  %3148 = and i1 %is_zero749, %3147, !dbg !1096
  %is_tiny752 = or i1 %is_subnormal748, %3148, !dbg !1096
  %underflow_cond753 = and i1 %3132, %is_tiny752, !dbg !1096
  br i1 %underflow_cond753, label %3149, label %3151, !dbg !1096

3149:                                             ; preds = %3117
  %3150 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3151, !dbg !1096

3151:                                             ; preds = %3117, %3149
  %3152 = bitcast float %2266 to i32, !dbg !1096
  %3153 = and i32 %3152, 2139095040, !dbg !1096
  %3154 = icmp eq i32 %3153, 0, !dbg !1096
  %3155 = and i32 %3152, 8388607, !dbg !1096
  %3156 = icmp ne i32 %3155, 0, !dbg !1096
  %is_subnormal754 = and i1 %3154, %3156, !dbg !1096
  %3157 = xor i1 %is_subnormal754, true, !dbg !1096
  %3158 = and i1 true, %3157, !dbg !1096
  %3159 = and i1 %3158, true, !dbg !1096
  %3160 = bitcast float %2991 to i32, !dbg !1096
  %3161 = and i32 %3160, 2139095040, !dbg !1096
  %3162 = icmp eq i32 %3161, 0, !dbg !1096
  %3163 = and i32 %3160, 8388607, !dbg !1096
  %3164 = icmp ne i32 %3163, 0, !dbg !1096
  %is_subnormal755 = and i1 %3162, %3164, !dbg !1096
  %3165 = xor i1 %is_subnormal755, true, !dbg !1096
  %3166 = and i1 %3159, %3165, !dbg !1096
  %3167 = bitcast float %3099 to i32, !dbg !1096
  %3168 = and i32 %3167, 2139095040, !dbg !1096
  %3169 = icmp eq i32 %3168, 0, !dbg !1096
  %3170 = and i32 %3167, 8388607, !dbg !1096
  %3171 = icmp ne i32 %3170, 0, !dbg !1096
  %is_subnormal756 = and i1 %3169, %3171, !dbg !1096
  %subnormal_cond757 = and i1 %3166, %is_subnormal756, !dbg !1096
  br i1 %subnormal_cond757, label %3172, label %3174, !dbg !1096

3172:                                             ; preds = %3151
  %3173 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3174, !dbg !1096

3174:                                             ; preds = %3151, %3172
  %3175 = bitcast float %1685 to i32, !dbg !1096
  %3176 = bitcast float %1685 to i32, !dbg !1096
  %3177 = and i32 %3176, 2139095040, !dbg !1096
  %3178 = icmp eq i32 %3177, 2139095040, !dbg !1096
  %3179 = and i32 %3176, 8388607, !dbg !1096
  %3180 = icmp ne i32 %3179, 0, !dbg !1096
  %is_nan758 = and i1 %3178, %3180, !dbg !1096
  %3181 = and i32 %3175, 4194304, !dbg !1096
  %3182 = icmp eq i32 %3181, 0, !dbg !1096
  %is_snan759 = and i1 %is_nan758, %3182, !dbg !1096
  %3183 = or i1 %is_snan759, false, !dbg !1096
  %3184 = bitcast float %3099 to i32, !dbg !1096
  %3185 = bitcast float %3099 to i32, !dbg !1096
  %3186 = and i32 %3185, 2139095040, !dbg !1096
  %3187 = icmp eq i32 %3186, 2139095040, !dbg !1096
  %3188 = and i32 %3185, 8388607, !dbg !1096
  %3189 = icmp ne i32 %3188, 0, !dbg !1096
  %is_nan760 = and i1 %3187, %3189, !dbg !1096
  %3190 = and i32 %3184, 4194304, !dbg !1096
  %3191 = icmp eq i32 %3190, 0, !dbg !1096
  %is_snan761 = and i1 %is_nan760, %3191, !dbg !1096
  %3192 = or i1 %3183, %is_snan761, !dbg !1096
  %3193 = bitcast float %1685 to i32, !dbg !1096
  %3194 = and i32 %3193, 2147483647, !dbg !1096
  %is_zero762 = icmp eq i32 %3194, 0, !dbg !1096
  %3195 = and i1 %is_zero762, false, !dbg !1096
  %3196 = bitcast float %1685 to i32, !dbg !1096
  %3197 = and i32 %3196, 2139095040, !dbg !1096
  %3198 = icmp eq i32 %3197, 2139095040, !dbg !1096
  %3199 = and i32 %3196, 8388607, !dbg !1096
  %3200 = icmp eq i32 %3199, 0, !dbg !1096
  %is_inf763 = and i1 %3198, %3200, !dbg !1096
  %3201 = and i1 %is_inf763, false, !dbg !1096
  %3202 = or i1 %3195, %3201, !dbg !1096
  %3203 = or i1 %3192, %3202, !dbg !1096
  br i1 %3203, label %3204, label %3206, !dbg !1096

3204:                                             ; preds = %3174
  %3205 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3206, !dbg !1096

3206:                                             ; preds = %3174, %3204
  %3207 = call float @llvm.nvvm.fma.rn.f(float %1685, float 0x3E54ABC680000000, float %3099) #5, !dbg !1096
  %3208 = bitcast float %1685 to i32, !dbg !1096
  %3209 = and i32 %3208, 2139095040, !dbg !1096
  %is_finite764 = icmp ne i32 %3209, 2139095040, !dbg !1096
  %3210 = and i1 true, %is_finite764, !dbg !1096
  %3211 = and i1 %3210, true, !dbg !1096
  %3212 = bitcast float %3207 to i32, !dbg !1096
  %3213 = and i32 %3212, 2139095040, !dbg !1096
  %3214 = icmp eq i32 %3213, 2139095040, !dbg !1096
  %3215 = and i32 %3212, 8388607, !dbg !1096
  %3216 = icmp eq i32 %3215, 0, !dbg !1096
  %is_inf765 = and i1 %3214, %3216, !dbg !1096
  %3217 = bitcast float %3207 to i32, !dbg !1096
  %3218 = and i32 %3217, 2147483647, !dbg !1096
  %is_maxfinite766 = icmp eq i32 %3218, 2139095039, !dbg !1096
  %3219 = bitcast float %3207 to i32, !dbg !1096
  %3220 = and i32 %3219, -2147483648, !dbg !1096
  %3221 = icmp eq i32 %3220, 0, !dbg !1096
  %3222 = icmp ne i32 %3220, 0, !dbg !1096
  %is_pos_inf767 = and i1 %is_inf765, %3221, !dbg !1096
  %is_neg_inf768 = and i1 %is_inf765, %3222, !dbg !1096
  %is_pos_max769 = and i1 %is_maxfinite766, %3221, !dbg !1096
  %is_neg_max770 = and i1 %is_maxfinite766, %3222, !dbg !1096
  %overflow_cond771 = and i1 %3211, %is_inf765, !dbg !1096
  br i1 %overflow_cond771, label %3223, label %3225, !dbg !1096

3223:                                             ; preds = %3206
  %3224 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3225, !dbg !1096

3225:                                             ; preds = %3206, %3223
  %3226 = bitcast float %1685 to i32, !dbg !1096
  %3227 = and i32 %3226, 2139095040, !dbg !1096
  %3228 = icmp eq i32 %3227, 0, !dbg !1096
  %3229 = and i32 %3226, 8388607, !dbg !1096
  %3230 = icmp ne i32 %3229, 0, !dbg !1096
  %is_subnormal772 = and i1 %3228, %3230, !dbg !1096
  %3231 = xor i1 %is_subnormal772, true, !dbg !1096
  %3232 = and i1 true, %3231, !dbg !1096
  %3233 = and i1 %3232, true, !dbg !1096
  %3234 = bitcast float %3099 to i32, !dbg !1096
  %3235 = and i32 %3234, 2139095040, !dbg !1096
  %3236 = icmp eq i32 %3235, 0, !dbg !1096
  %3237 = and i32 %3234, 8388607, !dbg !1096
  %3238 = icmp ne i32 %3237, 0, !dbg !1096
  %is_subnormal773 = and i1 %3236, %3238, !dbg !1096
  %3239 = xor i1 %is_subnormal773, true, !dbg !1096
  %3240 = and i1 %3233, %3239, !dbg !1096
  %3241 = bitcast float %3207 to i32, !dbg !1096
  %3242 = and i32 %3241, 2139095040, !dbg !1096
  %3243 = icmp eq i32 %3242, 0, !dbg !1096
  %3244 = and i32 %3241, 8388607, !dbg !1096
  %3245 = icmp ne i32 %3244, 0, !dbg !1096
  %is_subnormal774 = and i1 %3243, %3245, !dbg !1096
  %3246 = bitcast float %3207 to i32, !dbg !1096
  %3247 = and i32 %3246, 2147483647, !dbg !1096
  %is_zero775 = icmp eq i32 %3247, 0, !dbg !1096
  %3248 = bitcast float %1685 to i32, !dbg !1096
  %3249 = and i32 %3248, 2147483647, !dbg !1096
  %is_zero776 = icmp eq i32 %3249, 0, !dbg !1096
  %3250 = xor i1 %is_zero776, true, !dbg !1096
  %3251 = bitcast float %3099 to i32, !dbg !1096
  %3252 = and i32 %3251, 2147483647, !dbg !1096
  %is_zero777 = icmp eq i32 %3252, 0, !dbg !1096
  %3253 = xor i1 %is_zero777, true, !dbg !1096
  %3254 = and i1 %3250, true, !dbg !1096
  %3255 = and i1 %3254, %3253, !dbg !1096
  %3256 = and i1 %is_zero775, %3255, !dbg !1096
  %is_tiny778 = or i1 %is_subnormal774, %3256, !dbg !1096
  %underflow_cond779 = and i1 %3240, %is_tiny778, !dbg !1096
  br i1 %underflow_cond779, label %3257, label %3259, !dbg !1096

3257:                                             ; preds = %3225
  %3258 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3259, !dbg !1096

3259:                                             ; preds = %3225, %3257
  %3260 = bitcast float %1685 to i32, !dbg !1096
  %3261 = and i32 %3260, 2139095040, !dbg !1096
  %3262 = icmp eq i32 %3261, 0, !dbg !1096
  %3263 = and i32 %3260, 8388607, !dbg !1096
  %3264 = icmp ne i32 %3263, 0, !dbg !1096
  %is_subnormal780 = and i1 %3262, %3264, !dbg !1096
  %3265 = xor i1 %is_subnormal780, true, !dbg !1096
  %3266 = and i1 true, %3265, !dbg !1096
  %3267 = and i1 %3266, true, !dbg !1096
  %3268 = bitcast float %3099 to i32, !dbg !1096
  %3269 = and i32 %3268, 2139095040, !dbg !1096
  %3270 = icmp eq i32 %3269, 0, !dbg !1096
  %3271 = and i32 %3268, 8388607, !dbg !1096
  %3272 = icmp ne i32 %3271, 0, !dbg !1096
  %is_subnormal781 = and i1 %3270, %3272, !dbg !1096
  %3273 = xor i1 %is_subnormal781, true, !dbg !1096
  %3274 = and i1 %3267, %3273, !dbg !1096
  %3275 = bitcast float %3207 to i32, !dbg !1096
  %3276 = and i32 %3275, 2139095040, !dbg !1096
  %3277 = icmp eq i32 %3276, 0, !dbg !1096
  %3278 = and i32 %3275, 8388607, !dbg !1096
  %3279 = icmp ne i32 %3278, 0, !dbg !1096
  %is_subnormal782 = and i1 %3277, %3279, !dbg !1096
  %subnormal_cond783 = and i1 %3274, %is_subnormal782, !dbg !1096
  br i1 %subnormal_cond783, label %3280, label %3282, !dbg !1096

3280:                                             ; preds = %3259
  %3281 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3282, !dbg !1096

3282:                                             ; preds = %3259, %3280
  %3283 = bitcast float %2695 to i32, !dbg !1096
  %3284 = bitcast float %2695 to i32, !dbg !1096
  %3285 = and i32 %3284, 2139095040, !dbg !1096
  %3286 = icmp eq i32 %3285, 2139095040, !dbg !1096
  %3287 = and i32 %3284, 8388607, !dbg !1096
  %3288 = icmp ne i32 %3287, 0, !dbg !1096
  %is_nan784 = and i1 %3286, %3288, !dbg !1096
  %3289 = and i32 %3283, 4194304, !dbg !1096
  %3290 = icmp eq i32 %3289, 0, !dbg !1096
  %is_snan785 = and i1 %is_nan784, %3290, !dbg !1096
  %3291 = or i1 false, %is_snan785, !dbg !1096
  %3292 = bitcast float %2695 to i32, !dbg !1096
  %3293 = and i32 %3292, 2139095040, !dbg !1096
  %3294 = icmp eq i32 %3293, 2139095040, !dbg !1096
  %3295 = and i32 %3292, 8388607, !dbg !1096
  %3296 = icmp eq i32 %3295, 0, !dbg !1096
  %is_inf786 = and i1 %3294, %3296, !dbg !1096
  %3297 = and i1 false, %is_inf786, !dbg !1096
  %3298 = bitcast float %2695 to i32, !dbg !1096
  %3299 = and i32 %3298, 2147483647, !dbg !1096
  %is_zero787 = icmp eq i32 %3299, 0, !dbg !1096
  %3300 = and i1 false, %is_zero787, !dbg !1096
  %3301 = or i1 %3297, %3300, !dbg !1096
  %3302 = or i1 %3291, %3301, !dbg !1096
  br i1 %3302, label %3303, label %3305, !dbg !1096

3303:                                             ; preds = %3282
  %3304 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3305, !dbg !1096

3305:                                             ; preds = %3282, %3303
  %3306 = fmul float 3.000000e+00, %2695, !dbg !1096
  %3307 = bitcast float %2695 to i32, !dbg !1096
  %3308 = and i32 %3307, 2139095040, !dbg !1096
  %is_finite788 = icmp ne i32 %3308, 2139095040, !dbg !1096
  %3309 = and i1 true, %is_finite788, !dbg !1096
  %3310 = bitcast float %3306 to i32, !dbg !1096
  %3311 = and i32 %3310, 2139095040, !dbg !1096
  %3312 = icmp eq i32 %3311, 2139095040, !dbg !1096
  %3313 = and i32 %3310, 8388607, !dbg !1096
  %3314 = icmp eq i32 %3313, 0, !dbg !1096
  %is_inf789 = and i1 %3312, %3314, !dbg !1096
  %3315 = bitcast float %3306 to i32, !dbg !1096
  %3316 = and i32 %3315, 2147483647, !dbg !1096
  %is_maxfinite790 = icmp eq i32 %3316, 2139095039, !dbg !1096
  %3317 = bitcast float %3306 to i32, !dbg !1096
  %3318 = and i32 %3317, -2147483648, !dbg !1096
  %3319 = icmp eq i32 %3318, 0, !dbg !1096
  %3320 = icmp ne i32 %3318, 0, !dbg !1096
  %is_pos_inf791 = and i1 %is_inf789, %3319, !dbg !1096
  %is_neg_inf792 = and i1 %is_inf789, %3320, !dbg !1096
  %is_pos_max793 = and i1 %is_maxfinite790, %3319, !dbg !1096
  %is_neg_max794 = and i1 %is_maxfinite790, %3320, !dbg !1096
  %overflow_cond795 = and i1 %3309, %is_inf789, !dbg !1096
  br i1 %overflow_cond795, label %3321, label %3323, !dbg !1096

3321:                                             ; preds = %3305
  %3322 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3323, !dbg !1096

3323:                                             ; preds = %3305, %3321
  %3324 = bitcast float %2695 to i32, !dbg !1096
  %3325 = and i32 %3324, 2139095040, !dbg !1096
  %3326 = icmp eq i32 %3325, 0, !dbg !1096
  %3327 = and i32 %3324, 8388607, !dbg !1096
  %3328 = icmp ne i32 %3327, 0, !dbg !1096
  %is_subnormal796 = and i1 %3326, %3328, !dbg !1096
  %3329 = xor i1 %is_subnormal796, true, !dbg !1096
  %3330 = and i1 true, %3329, !dbg !1096
  %3331 = bitcast float %3306 to i32, !dbg !1096
  %3332 = and i32 %3331, 2139095040, !dbg !1096
  %3333 = icmp eq i32 %3332, 0, !dbg !1096
  %3334 = and i32 %3331, 8388607, !dbg !1096
  %3335 = icmp ne i32 %3334, 0, !dbg !1096
  %is_subnormal797 = and i1 %3333, %3335, !dbg !1096
  %3336 = bitcast float %3306 to i32, !dbg !1096
  %3337 = and i32 %3336, 2147483647, !dbg !1096
  %is_zero798 = icmp eq i32 %3337, 0, !dbg !1096
  %3338 = bitcast float %2695 to i32, !dbg !1096
  %3339 = and i32 %3338, 2147483647, !dbg !1096
  %is_zero799 = icmp eq i32 %3339, 0, !dbg !1096
  %3340 = xor i1 %is_zero799, true, !dbg !1096
  %3341 = and i1 true, %3340, !dbg !1096
  %3342 = and i1 %is_zero798, %3341, !dbg !1096
  %is_tiny800 = or i1 %is_subnormal797, %3342, !dbg !1096
  %underflow_cond801 = and i1 %3330, %is_tiny800, !dbg !1096
  br i1 %underflow_cond801, label %3343, label %3345, !dbg !1096

3343:                                             ; preds = %3323
  %3344 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3345, !dbg !1096

3345:                                             ; preds = %3323, %3343
  %3346 = bitcast float %2695 to i32, !dbg !1096
  %3347 = and i32 %3346, 2139095040, !dbg !1096
  %3348 = icmp eq i32 %3347, 0, !dbg !1096
  %3349 = and i32 %3346, 8388607, !dbg !1096
  %3350 = icmp ne i32 %3349, 0, !dbg !1096
  %is_subnormal802 = and i1 %3348, %3350, !dbg !1096
  %3351 = xor i1 %is_subnormal802, true, !dbg !1096
  %3352 = and i1 true, %3351, !dbg !1096
  %3353 = bitcast float %3306 to i32, !dbg !1096
  %3354 = and i32 %3353, 2139095040, !dbg !1096
  %3355 = icmp eq i32 %3354, 0, !dbg !1096
  %3356 = and i32 %3353, 8388607, !dbg !1096
  %3357 = icmp ne i32 %3356, 0, !dbg !1096
  %is_subnormal803 = and i1 %3355, %3357, !dbg !1096
  %subnormal_cond804 = and i1 %3352, %is_subnormal803, !dbg !1096
  br i1 %subnormal_cond804, label %3358, label %3360, !dbg !1096

3358:                                             ; preds = %3345
  %3359 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3360, !dbg !1096

3360:                                             ; preds = %3345, %3358
  %3361 = bitcast float %3306 to i32, !dbg !1096
  %3362 = bitcast float %3306 to i32, !dbg !1096
  %3363 = and i32 %3362, 2139095040, !dbg !1096
  %3364 = icmp eq i32 %3363, 2139095040, !dbg !1096
  %3365 = and i32 %3362, 8388607, !dbg !1096
  %3366 = icmp ne i32 %3365, 0, !dbg !1096
  %is_nan805 = and i1 %3364, %3366, !dbg !1096
  %3367 = and i32 %3361, 4194304, !dbg !1096
  %3368 = icmp eq i32 %3367, 0, !dbg !1096
  %is_snan806 = and i1 %is_nan805, %3368, !dbg !1096
  %3369 = bitcast float %2266 to i32, !dbg !1096
  %3370 = bitcast float %2266 to i32, !dbg !1096
  %3371 = and i32 %3370, 2139095040, !dbg !1096
  %3372 = icmp eq i32 %3371, 2139095040, !dbg !1096
  %3373 = and i32 %3370, 8388607, !dbg !1096
  %3374 = icmp ne i32 %3373, 0, !dbg !1096
  %is_nan807 = and i1 %3372, %3374, !dbg !1096
  %3375 = and i32 %3369, 4194304, !dbg !1096
  %3376 = icmp eq i32 %3375, 0, !dbg !1096
  %is_snan808 = and i1 %is_nan807, %3376, !dbg !1096
  %3377 = or i1 %is_snan806, %is_snan808, !dbg !1096
  %3378 = bitcast float %3207 to i32, !dbg !1096
  %3379 = bitcast float %3207 to i32, !dbg !1096
  %3380 = and i32 %3379, 2139095040, !dbg !1096
  %3381 = icmp eq i32 %3380, 2139095040, !dbg !1096
  %3382 = and i32 %3379, 8388607, !dbg !1096
  %3383 = icmp ne i32 %3382, 0, !dbg !1096
  %is_nan809 = and i1 %3381, %3383, !dbg !1096
  %3384 = and i32 %3378, 4194304, !dbg !1096
  %3385 = icmp eq i32 %3384, 0, !dbg !1096
  %is_snan810 = and i1 %is_nan809, %3385, !dbg !1096
  %3386 = or i1 %3377, %is_snan810, !dbg !1096
  %3387 = bitcast float %3306 to i32, !dbg !1096
  %3388 = and i32 %3387, 2147483647, !dbg !1096
  %is_zero811 = icmp eq i32 %3388, 0, !dbg !1096
  %3389 = bitcast float %2266 to i32, !dbg !1096
  %3390 = and i32 %3389, 2139095040, !dbg !1096
  %3391 = icmp eq i32 %3390, 2139095040, !dbg !1096
  %3392 = and i32 %3389, 8388607, !dbg !1096
  %3393 = icmp eq i32 %3392, 0, !dbg !1096
  %is_inf812 = and i1 %3391, %3393, !dbg !1096
  %3394 = and i1 %is_zero811, %is_inf812, !dbg !1096
  %3395 = bitcast float %3306 to i32, !dbg !1096
  %3396 = and i32 %3395, 2139095040, !dbg !1096
  %3397 = icmp eq i32 %3396, 2139095040, !dbg !1096
  %3398 = and i32 %3395, 8388607, !dbg !1096
  %3399 = icmp eq i32 %3398, 0, !dbg !1096
  %is_inf813 = and i1 %3397, %3399, !dbg !1096
  %3400 = bitcast float %2266 to i32, !dbg !1096
  %3401 = and i32 %3400, 2147483647, !dbg !1096
  %is_zero814 = icmp eq i32 %3401, 0, !dbg !1096
  %3402 = and i1 %is_inf813, %is_zero814, !dbg !1096
  %3403 = or i1 %3394, %3402, !dbg !1096
  %3404 = or i1 %3386, %3403, !dbg !1096
  br i1 %3404, label %3405, label %3407, !dbg !1096

3405:                                             ; preds = %3360
  %3406 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3407, !dbg !1096

3407:                                             ; preds = %3360, %3405
  %3408 = call float @llvm.nvvm.fma.rn.f(float %3306, float %2266, float %3207) #5, !dbg !1096
  %3409 = bitcast float %3306 to i32, !dbg !1096
  %3410 = and i32 %3409, 2139095040, !dbg !1096
  %is_finite815 = icmp ne i32 %3410, 2139095040, !dbg !1096
  %3411 = and i1 true, %is_finite815, !dbg !1096
  %3412 = bitcast float %2266 to i32, !dbg !1096
  %3413 = and i32 %3412, 2139095040, !dbg !1096
  %is_finite816 = icmp ne i32 %3413, 2139095040, !dbg !1096
  %3414 = and i1 %3411, %is_finite816, !dbg !1096
  %3415 = bitcast float %3408 to i32, !dbg !1096
  %3416 = and i32 %3415, 2139095040, !dbg !1096
  %3417 = icmp eq i32 %3416, 2139095040, !dbg !1096
  %3418 = and i32 %3415, 8388607, !dbg !1096
  %3419 = icmp eq i32 %3418, 0, !dbg !1096
  %is_inf817 = and i1 %3417, %3419, !dbg !1096
  %3420 = bitcast float %3408 to i32, !dbg !1096
  %3421 = and i32 %3420, 2147483647, !dbg !1096
  %is_maxfinite818 = icmp eq i32 %3421, 2139095039, !dbg !1096
  %3422 = bitcast float %3408 to i32, !dbg !1096
  %3423 = and i32 %3422, -2147483648, !dbg !1096
  %3424 = icmp eq i32 %3423, 0, !dbg !1096
  %3425 = icmp ne i32 %3423, 0, !dbg !1096
  %is_pos_inf819 = and i1 %is_inf817, %3424, !dbg !1096
  %is_neg_inf820 = and i1 %is_inf817, %3425, !dbg !1096
  %is_pos_max821 = and i1 %is_maxfinite818, %3424, !dbg !1096
  %is_neg_max822 = and i1 %is_maxfinite818, %3425, !dbg !1096
  %overflow_cond823 = and i1 %3414, %is_inf817, !dbg !1096
  br i1 %overflow_cond823, label %3426, label %3428, !dbg !1096

3426:                                             ; preds = %3407
  %3427 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3428, !dbg !1096

3428:                                             ; preds = %3407, %3426
  %3429 = bitcast float %3306 to i32, !dbg !1096
  %3430 = and i32 %3429, 2139095040, !dbg !1096
  %3431 = icmp eq i32 %3430, 0, !dbg !1096
  %3432 = and i32 %3429, 8388607, !dbg !1096
  %3433 = icmp ne i32 %3432, 0, !dbg !1096
  %is_subnormal824 = and i1 %3431, %3433, !dbg !1096
  %3434 = xor i1 %is_subnormal824, true, !dbg !1096
  %3435 = and i1 true, %3434, !dbg !1096
  %3436 = bitcast float %2266 to i32, !dbg !1096
  %3437 = and i32 %3436, 2139095040, !dbg !1096
  %3438 = icmp eq i32 %3437, 0, !dbg !1096
  %3439 = and i32 %3436, 8388607, !dbg !1096
  %3440 = icmp ne i32 %3439, 0, !dbg !1096
  %is_subnormal825 = and i1 %3438, %3440, !dbg !1096
  %3441 = xor i1 %is_subnormal825, true, !dbg !1096
  %3442 = and i1 %3435, %3441, !dbg !1096
  %3443 = bitcast float %3207 to i32, !dbg !1096
  %3444 = and i32 %3443, 2139095040, !dbg !1096
  %3445 = icmp eq i32 %3444, 0, !dbg !1096
  %3446 = and i32 %3443, 8388607, !dbg !1096
  %3447 = icmp ne i32 %3446, 0, !dbg !1096
  %is_subnormal826 = and i1 %3445, %3447, !dbg !1096
  %3448 = xor i1 %is_subnormal826, true, !dbg !1096
  %3449 = and i1 %3442, %3448, !dbg !1096
  %3450 = bitcast float %3408 to i32, !dbg !1096
  %3451 = and i32 %3450, 2139095040, !dbg !1096
  %3452 = icmp eq i32 %3451, 0, !dbg !1096
  %3453 = and i32 %3450, 8388607, !dbg !1096
  %3454 = icmp ne i32 %3453, 0, !dbg !1096
  %is_subnormal827 = and i1 %3452, %3454, !dbg !1096
  %3455 = bitcast float %3408 to i32, !dbg !1096
  %3456 = and i32 %3455, 2147483647, !dbg !1096
  %is_zero828 = icmp eq i32 %3456, 0, !dbg !1096
  %3457 = bitcast float %3306 to i32, !dbg !1096
  %3458 = and i32 %3457, 2147483647, !dbg !1096
  %is_zero829 = icmp eq i32 %3458, 0, !dbg !1096
  %3459 = xor i1 %is_zero829, true, !dbg !1096
  %3460 = bitcast float %2266 to i32, !dbg !1096
  %3461 = and i32 %3460, 2147483647, !dbg !1096
  %is_zero830 = icmp eq i32 %3461, 0, !dbg !1096
  %3462 = xor i1 %is_zero830, true, !dbg !1096
  %3463 = bitcast float %3207 to i32, !dbg !1096
  %3464 = and i32 %3463, 2147483647, !dbg !1096
  %is_zero831 = icmp eq i32 %3464, 0, !dbg !1096
  %3465 = xor i1 %is_zero831, true, !dbg !1096
  %3466 = and i1 %3459, %3462, !dbg !1096
  %3467 = and i1 %3466, %3465, !dbg !1096
  %3468 = and i1 %is_zero828, %3467, !dbg !1096
  %is_tiny832 = or i1 %is_subnormal827, %3468, !dbg !1096
  %underflow_cond833 = and i1 %3449, %is_tiny832, !dbg !1096
  br i1 %underflow_cond833, label %3469, label %3471, !dbg !1096

3469:                                             ; preds = %3428
  %3470 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3471, !dbg !1096

3471:                                             ; preds = %3428, %3469
  %3472 = bitcast float %3306 to i32, !dbg !1096
  %3473 = and i32 %3472, 2139095040, !dbg !1096
  %3474 = icmp eq i32 %3473, 0, !dbg !1096
  %3475 = and i32 %3472, 8388607, !dbg !1096
  %3476 = icmp ne i32 %3475, 0, !dbg !1096
  %is_subnormal834 = and i1 %3474, %3476, !dbg !1096
  %3477 = xor i1 %is_subnormal834, true, !dbg !1096
  %3478 = and i1 true, %3477, !dbg !1096
  %3479 = bitcast float %2266 to i32, !dbg !1096
  %3480 = and i32 %3479, 2139095040, !dbg !1096
  %3481 = icmp eq i32 %3480, 0, !dbg !1096
  %3482 = and i32 %3479, 8388607, !dbg !1096
  %3483 = icmp ne i32 %3482, 0, !dbg !1096
  %is_subnormal835 = and i1 %3481, %3483, !dbg !1096
  %3484 = xor i1 %is_subnormal835, true, !dbg !1096
  %3485 = and i1 %3478, %3484, !dbg !1096
  %3486 = bitcast float %3207 to i32, !dbg !1096
  %3487 = and i32 %3486, 2139095040, !dbg !1096
  %3488 = icmp eq i32 %3487, 0, !dbg !1096
  %3489 = and i32 %3486, 8388607, !dbg !1096
  %3490 = icmp ne i32 %3489, 0, !dbg !1096
  %is_subnormal836 = and i1 %3488, %3490, !dbg !1096
  %3491 = xor i1 %is_subnormal836, true, !dbg !1096
  %3492 = and i1 %3485, %3491, !dbg !1096
  %3493 = bitcast float %3408 to i32, !dbg !1096
  %3494 = and i32 %3493, 2139095040, !dbg !1096
  %3495 = icmp eq i32 %3494, 0, !dbg !1096
  %3496 = and i32 %3493, 8388607, !dbg !1096
  %3497 = icmp ne i32 %3496, 0, !dbg !1096
  %is_subnormal837 = and i1 %3495, %3497, !dbg !1096
  %subnormal_cond838 = and i1 %3492, %is_subnormal837, !dbg !1096
  br i1 %subnormal_cond838, label %3498, label %3500, !dbg !1096

3498:                                             ; preds = %3471
  %3499 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3500, !dbg !1096

3500:                                             ; preds = %3471, %3498
  %3501 = bitcast float %2695 to i32, !dbg !1096
  %3502 = bitcast float %2695 to i32, !dbg !1096
  %3503 = and i32 %3502, 2139095040, !dbg !1096
  %3504 = icmp eq i32 %3503, 2139095040, !dbg !1096
  %3505 = and i32 %3502, 8388607, !dbg !1096
  %3506 = icmp ne i32 %3505, 0, !dbg !1096
  %is_nan839 = and i1 %3504, %3506, !dbg !1096
  %3507 = and i32 %3501, 4194304, !dbg !1096
  %3508 = icmp eq i32 %3507, 0, !dbg !1096
  %is_snan840 = and i1 %is_nan839, %3508, !dbg !1096
  %3509 = bitcast float %1685 to i32, !dbg !1096
  %3510 = bitcast float %1685 to i32, !dbg !1096
  %3511 = and i32 %3510, 2139095040, !dbg !1096
  %3512 = icmp eq i32 %3511, 2139095040, !dbg !1096
  %3513 = and i32 %3510, 8388607, !dbg !1096
  %3514 = icmp ne i32 %3513, 0, !dbg !1096
  %is_nan841 = and i1 %3512, %3514, !dbg !1096
  %3515 = and i32 %3509, 4194304, !dbg !1096
  %3516 = icmp eq i32 %3515, 0, !dbg !1096
  %is_snan842 = and i1 %is_nan841, %3516, !dbg !1096
  %3517 = or i1 %is_snan840, %is_snan842, !dbg !1096
  %3518 = bitcast float %3408 to i32, !dbg !1096
  %3519 = bitcast float %3408 to i32, !dbg !1096
  %3520 = and i32 %3519, 2139095040, !dbg !1096
  %3521 = icmp eq i32 %3520, 2139095040, !dbg !1096
  %3522 = and i32 %3519, 8388607, !dbg !1096
  %3523 = icmp ne i32 %3522, 0, !dbg !1096
  %is_nan843 = and i1 %3521, %3523, !dbg !1096
  %3524 = and i32 %3518, 4194304, !dbg !1096
  %3525 = icmp eq i32 %3524, 0, !dbg !1096
  %is_snan844 = and i1 %is_nan843, %3525, !dbg !1096
  %3526 = or i1 %3517, %is_snan844, !dbg !1096
  %3527 = bitcast float %2695 to i32, !dbg !1096
  %3528 = and i32 %3527, 2147483647, !dbg !1096
  %is_zero845 = icmp eq i32 %3528, 0, !dbg !1096
  %3529 = bitcast float %1685 to i32, !dbg !1096
  %3530 = and i32 %3529, 2139095040, !dbg !1096
  %3531 = icmp eq i32 %3530, 2139095040, !dbg !1096
  %3532 = and i32 %3529, 8388607, !dbg !1096
  %3533 = icmp eq i32 %3532, 0, !dbg !1096
  %is_inf846 = and i1 %3531, %3533, !dbg !1096
  %3534 = and i1 %is_zero845, %is_inf846, !dbg !1096
  %3535 = bitcast float %2695 to i32, !dbg !1096
  %3536 = and i32 %3535, 2139095040, !dbg !1096
  %3537 = icmp eq i32 %3536, 2139095040, !dbg !1096
  %3538 = and i32 %3535, 8388607, !dbg !1096
  %3539 = icmp eq i32 %3538, 0, !dbg !1096
  %is_inf847 = and i1 %3537, %3539, !dbg !1096
  %3540 = bitcast float %1685 to i32, !dbg !1096
  %3541 = and i32 %3540, 2147483647, !dbg !1096
  %is_zero848 = icmp eq i32 %3541, 0, !dbg !1096
  %3542 = and i1 %is_inf847, %is_zero848, !dbg !1096
  %3543 = or i1 %3534, %3542, !dbg !1096
  %3544 = or i1 %3526, %3543, !dbg !1096
  br i1 %3544, label %3545, label %3547, !dbg !1096

3545:                                             ; preds = %3500
  %3546 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3547, !dbg !1096

3547:                                             ; preds = %3500, %3545
  %3548 = call float @llvm.nvvm.fma.rn.f(float %2695, float %1685, float %3408) #5, !dbg !1096
  %3549 = bitcast float %2695 to i32, !dbg !1096
  %3550 = and i32 %3549, 2139095040, !dbg !1096
  %is_finite849 = icmp ne i32 %3550, 2139095040, !dbg !1096
  %3551 = and i1 true, %is_finite849, !dbg !1096
  %3552 = bitcast float %1685 to i32, !dbg !1096
  %3553 = and i32 %3552, 2139095040, !dbg !1096
  %is_finite850 = icmp ne i32 %3553, 2139095040, !dbg !1096
  %3554 = and i1 %3551, %is_finite850, !dbg !1096
  %3555 = bitcast float %3548 to i32, !dbg !1096
  %3556 = and i32 %3555, 2139095040, !dbg !1096
  %3557 = icmp eq i32 %3556, 2139095040, !dbg !1096
  %3558 = and i32 %3555, 8388607, !dbg !1096
  %3559 = icmp eq i32 %3558, 0, !dbg !1096
  %is_inf851 = and i1 %3557, %3559, !dbg !1096
  %3560 = bitcast float %3548 to i32, !dbg !1096
  %3561 = and i32 %3560, 2147483647, !dbg !1096
  %is_maxfinite852 = icmp eq i32 %3561, 2139095039, !dbg !1096
  %3562 = bitcast float %3548 to i32, !dbg !1096
  %3563 = and i32 %3562, -2147483648, !dbg !1096
  %3564 = icmp eq i32 %3563, 0, !dbg !1096
  %3565 = icmp ne i32 %3563, 0, !dbg !1096
  %is_pos_inf853 = and i1 %is_inf851, %3564, !dbg !1096
  %is_neg_inf854 = and i1 %is_inf851, %3565, !dbg !1096
  %is_pos_max855 = and i1 %is_maxfinite852, %3564, !dbg !1096
  %is_neg_max856 = and i1 %is_maxfinite852, %3565, !dbg !1096
  %overflow_cond857 = and i1 %3554, %is_inf851, !dbg !1096
  br i1 %overflow_cond857, label %3566, label %3568, !dbg !1096

3566:                                             ; preds = %3547
  %3567 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3568, !dbg !1096

3568:                                             ; preds = %3547, %3566
  %3569 = bitcast float %2695 to i32, !dbg !1096
  %3570 = and i32 %3569, 2139095040, !dbg !1096
  %3571 = icmp eq i32 %3570, 0, !dbg !1096
  %3572 = and i32 %3569, 8388607, !dbg !1096
  %3573 = icmp ne i32 %3572, 0, !dbg !1096
  %is_subnormal858 = and i1 %3571, %3573, !dbg !1096
  %3574 = xor i1 %is_subnormal858, true, !dbg !1096
  %3575 = and i1 true, %3574, !dbg !1096
  %3576 = bitcast float %1685 to i32, !dbg !1096
  %3577 = and i32 %3576, 2139095040, !dbg !1096
  %3578 = icmp eq i32 %3577, 0, !dbg !1096
  %3579 = and i32 %3576, 8388607, !dbg !1096
  %3580 = icmp ne i32 %3579, 0, !dbg !1096
  %is_subnormal859 = and i1 %3578, %3580, !dbg !1096
  %3581 = xor i1 %is_subnormal859, true, !dbg !1096
  %3582 = and i1 %3575, %3581, !dbg !1096
  %3583 = bitcast float %3408 to i32, !dbg !1096
  %3584 = and i32 %3583, 2139095040, !dbg !1096
  %3585 = icmp eq i32 %3584, 0, !dbg !1096
  %3586 = and i32 %3583, 8388607, !dbg !1096
  %3587 = icmp ne i32 %3586, 0, !dbg !1096
  %is_subnormal860 = and i1 %3585, %3587, !dbg !1096
  %3588 = xor i1 %is_subnormal860, true, !dbg !1096
  %3589 = and i1 %3582, %3588, !dbg !1096
  %3590 = bitcast float %3548 to i32, !dbg !1096
  %3591 = and i32 %3590, 2139095040, !dbg !1096
  %3592 = icmp eq i32 %3591, 0, !dbg !1096
  %3593 = and i32 %3590, 8388607, !dbg !1096
  %3594 = icmp ne i32 %3593, 0, !dbg !1096
  %is_subnormal861 = and i1 %3592, %3594, !dbg !1096
  %3595 = bitcast float %3548 to i32, !dbg !1096
  %3596 = and i32 %3595, 2147483647, !dbg !1096
  %is_zero862 = icmp eq i32 %3596, 0, !dbg !1096
  %3597 = bitcast float %2695 to i32, !dbg !1096
  %3598 = and i32 %3597, 2147483647, !dbg !1096
  %is_zero863 = icmp eq i32 %3598, 0, !dbg !1096
  %3599 = xor i1 %is_zero863, true, !dbg !1096
  %3600 = bitcast float %1685 to i32, !dbg !1096
  %3601 = and i32 %3600, 2147483647, !dbg !1096
  %is_zero864 = icmp eq i32 %3601, 0, !dbg !1096
  %3602 = xor i1 %is_zero864, true, !dbg !1096
  %3603 = bitcast float %3408 to i32, !dbg !1096
  %3604 = and i32 %3603, 2147483647, !dbg !1096
  %is_zero865 = icmp eq i32 %3604, 0, !dbg !1096
  %3605 = xor i1 %is_zero865, true, !dbg !1096
  %3606 = and i1 %3599, %3602, !dbg !1096
  %3607 = and i1 %3606, %3605, !dbg !1096
  %3608 = and i1 %is_zero862, %3607, !dbg !1096
  %is_tiny866 = or i1 %is_subnormal861, %3608, !dbg !1096
  %underflow_cond867 = and i1 %3589, %is_tiny866, !dbg !1096
  br i1 %underflow_cond867, label %3609, label %3611, !dbg !1096

3609:                                             ; preds = %3568
  %3610 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %3611, !dbg !1096

3611:                                             ; preds = %3568, %3609
  %3612 = bitcast float %2695 to i32, !dbg !1096
  %3613 = and i32 %3612, 2139095040, !dbg !1096
  %3614 = icmp eq i32 %3613, 0, !dbg !1096
  %3615 = and i32 %3612, 8388607, !dbg !1096
  %3616 = icmp ne i32 %3615, 0, !dbg !1096
  %is_subnormal868 = and i1 %3614, %3616, !dbg !1096
  %3617 = xor i1 %is_subnormal868, true, !dbg !1096
  %3618 = and i1 true, %3617, !dbg !1096
  %3619 = bitcast float %1685 to i32, !dbg !1096
  %3620 = and i32 %3619, 2139095040, !dbg !1096
  %3621 = icmp eq i32 %3620, 0, !dbg !1096
  %3622 = and i32 %3619, 8388607, !dbg !1096
  %3623 = icmp ne i32 %3622, 0, !dbg !1096
  %is_subnormal869 = and i1 %3621, %3623, !dbg !1096
  %3624 = xor i1 %is_subnormal869, true, !dbg !1096
  %3625 = and i1 %3618, %3624, !dbg !1096
  %3626 = bitcast float %3408 to i32, !dbg !1096
  %3627 = and i32 %3626, 2139095040, !dbg !1096
  %3628 = icmp eq i32 %3627, 0, !dbg !1096
  %3629 = and i32 %3626, 8388607, !dbg !1096
  %3630 = icmp ne i32 %3629, 0, !dbg !1096
  %is_subnormal870 = and i1 %3628, %3630, !dbg !1096
  %3631 = xor i1 %is_subnormal870, true, !dbg !1096
  %3632 = and i1 %3625, %3631, !dbg !1096
  %3633 = bitcast float %3548 to i32, !dbg !1096
  %3634 = and i32 %3633, 2139095040, !dbg !1096
  %3635 = icmp eq i32 %3634, 0, !dbg !1096
  %3636 = and i32 %3633, 8388607, !dbg !1096
  %3637 = icmp ne i32 %3636, 0, !dbg !1096
  %is_subnormal871 = and i1 %3635, %3637, !dbg !1096
  %subnormal_cond872 = and i1 %3632, %is_subnormal871, !dbg !1096
  br i1 %subnormal_cond872, label %3638, label %3640, !dbg !1096

3638:                                             ; preds = %3611
  %3639 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3640, !dbg !1096

3640:                                             ; preds = %3611, %3638
  %3641 = bitcast float %2802 to i32, !dbg !1096
  %3642 = bitcast float %2802 to i32, !dbg !1096
  %3643 = and i32 %3642, 2139095040, !dbg !1096
  %3644 = icmp eq i32 %3643, 2139095040, !dbg !1096
  %3645 = and i32 %3642, 8388607, !dbg !1096
  %3646 = icmp ne i32 %3645, 0, !dbg !1096
  %is_nan873 = and i1 %3644, %3646, !dbg !1096
  %3647 = and i32 %3641, 4194304, !dbg !1096
  %3648 = icmp eq i32 %3647, 0, !dbg !1096
  %is_snan874 = and i1 %is_nan873, %3648, !dbg !1096
  %3649 = bitcast float %3548 to i32, !dbg !1096
  %3650 = bitcast float %3548 to i32, !dbg !1096
  %3651 = and i32 %3650, 2139095040, !dbg !1096
  %3652 = icmp eq i32 %3651, 2139095040, !dbg !1096
  %3653 = and i32 %3650, 8388607, !dbg !1096
  %3654 = icmp ne i32 %3653, 0, !dbg !1096
  %is_nan875 = and i1 %3652, %3654, !dbg !1096
  %3655 = and i32 %3649, 4194304, !dbg !1096
  %3656 = icmp eq i32 %3655, 0, !dbg !1096
  %is_snan876 = and i1 %is_nan875, %3656, !dbg !1096
  %3657 = or i1 %is_snan874, %is_snan876, !dbg !1096
  %3658 = bitcast float %2802 to i32, !dbg !1096
  %3659 = and i32 %3658, 2139095040, !dbg !1096
  %3660 = icmp eq i32 %3659, 2139095040, !dbg !1096
  %3661 = and i32 %3658, 8388607, !dbg !1096
  %3662 = icmp eq i32 %3661, 0, !dbg !1096
  %is_inf877 = and i1 %3660, %3662, !dbg !1096
  %3663 = bitcast float %3548 to i32, !dbg !1096
  %3664 = and i32 %3663, 2139095040, !dbg !1096
  %3665 = icmp eq i32 %3664, 2139095040, !dbg !1096
  %3666 = and i32 %3663, 8388607, !dbg !1096
  %3667 = icmp eq i32 %3666, 0, !dbg !1096
  %is_inf878 = and i1 %3665, %3667, !dbg !1096
  %3668 = and i1 %is_inf877, %is_inf878, !dbg !1096
  %3669 = bitcast float %2802 to i32, !dbg !1096
  %3670 = bitcast float %3548 to i32, !dbg !1096
  %3671 = and i32 %3669, -2147483648, !dbg !1096
  %3672 = and i32 %3670, -2147483648, !dbg !1096
  %3673 = icmp ne i32 %3671, %3672, !dbg !1096
  %3674 = and i1 %3668, %3673, !dbg !1096
  %3675 = or i1 %3657, %3674, !dbg !1096
  br i1 %3675, label %3676, label %3678, !dbg !1096

3676:                                             ; preds = %3640
  %3677 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3678, !dbg !1096

3678:                                             ; preds = %3640, %3676
  %3679 = call float @llvm.nvvm.add.rn.f(float %2802, float %3548) #5, !dbg !1096
  %3680 = bitcast float %2802 to i32, !dbg !1096
  %3681 = and i32 %3680, 2139095040, !dbg !1096
  %is_finite879 = icmp ne i32 %3681, 2139095040, !dbg !1096
  %3682 = and i1 true, %is_finite879, !dbg !1096
  %3683 = bitcast float %3548 to i32, !dbg !1096
  %3684 = and i32 %3683, 2139095040, !dbg !1096
  %is_finite880 = icmp ne i32 %3684, 2139095040, !dbg !1096
  %3685 = and i1 %3682, %is_finite880, !dbg !1096
  %3686 = bitcast float %3679 to i32, !dbg !1096
  %3687 = and i32 %3686, 2139095040, !dbg !1096
  %3688 = icmp eq i32 %3687, 2139095040, !dbg !1096
  %3689 = and i32 %3686, 8388607, !dbg !1096
  %3690 = icmp eq i32 %3689, 0, !dbg !1096
  %is_inf881 = and i1 %3688, %3690, !dbg !1096
  %3691 = bitcast float %3679 to i32, !dbg !1096
  %3692 = and i32 %3691, 2147483647, !dbg !1096
  %is_maxfinite882 = icmp eq i32 %3692, 2139095039, !dbg !1096
  %3693 = bitcast float %3679 to i32, !dbg !1096
  %3694 = and i32 %3693, -2147483648, !dbg !1096
  %3695 = icmp eq i32 %3694, 0, !dbg !1096
  %3696 = icmp ne i32 %3694, 0, !dbg !1096
  %is_pos_inf883 = and i1 %is_inf881, %3695, !dbg !1096
  %is_neg_inf884 = and i1 %is_inf881, %3696, !dbg !1096
  %is_pos_max885 = and i1 %is_maxfinite882, %3695, !dbg !1096
  %is_neg_max886 = and i1 %is_maxfinite882, %3696, !dbg !1096
  %overflow_cond887 = and i1 %3685, %is_inf881, !dbg !1096
  br i1 %overflow_cond887, label %3697, label %3699, !dbg !1096

3697:                                             ; preds = %3678
  %3698 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3699, !dbg !1096

3699:                                             ; preds = %3678, %3697
  %3700 = bitcast float %2802 to i32, !dbg !1096
  %3701 = and i32 %3700, 2139095040, !dbg !1096
  %3702 = icmp eq i32 %3701, 0, !dbg !1096
  %3703 = and i32 %3700, 8388607, !dbg !1096
  %3704 = icmp ne i32 %3703, 0, !dbg !1096
  %is_subnormal888 = and i1 %3702, %3704, !dbg !1096
  %3705 = xor i1 %is_subnormal888, true, !dbg !1096
  %3706 = and i1 true, %3705, !dbg !1096
  %3707 = bitcast float %3548 to i32, !dbg !1096
  %3708 = and i32 %3707, 2139095040, !dbg !1096
  %3709 = icmp eq i32 %3708, 0, !dbg !1096
  %3710 = and i32 %3707, 8388607, !dbg !1096
  %3711 = icmp ne i32 %3710, 0, !dbg !1096
  %is_subnormal889 = and i1 %3709, %3711, !dbg !1096
  %3712 = xor i1 %is_subnormal889, true, !dbg !1096
  %3713 = and i1 %3706, %3712, !dbg !1096
  %3714 = bitcast float %3679 to i32, !dbg !1096
  %3715 = and i32 %3714, 2139095040, !dbg !1096
  %3716 = icmp eq i32 %3715, 0, !dbg !1096
  %3717 = and i32 %3714, 8388607, !dbg !1096
  %3718 = icmp ne i32 %3717, 0, !dbg !1096
  %is_subnormal890 = and i1 %3716, %3718, !dbg !1096
  %subnormal_cond891 = and i1 %3713, %is_subnormal890, !dbg !1096
  br i1 %subnormal_cond891, label %3719, label %3721, !dbg !1096

3719:                                             ; preds = %3699
  %3720 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3721, !dbg !1096

3721:                                             ; preds = %3699, %3719
  %3722 = bitcast float %2802 to i32, !dbg !1096
  %3723 = bitcast float %2802 to i32, !dbg !1096
  %3724 = and i32 %3723, 2139095040, !dbg !1096
  %3725 = icmp eq i32 %3724, 2139095040, !dbg !1096
  %3726 = and i32 %3723, 8388607, !dbg !1096
  %3727 = icmp ne i32 %3726, 0, !dbg !1096
  %is_nan892 = and i1 %3725, %3727, !dbg !1096
  %3728 = and i32 %3722, 4194304, !dbg !1096
  %3729 = icmp eq i32 %3728, 0, !dbg !1096
  %is_snan893 = and i1 %is_nan892, %3729, !dbg !1096
  %3730 = or i1 false, %is_snan893, !dbg !1096
  %3731 = bitcast float %2802 to i32, !dbg !1096
  %3732 = and i32 %3731, 2139095040, !dbg !1096
  %3733 = icmp eq i32 %3732, 2139095040, !dbg !1096
  %3734 = and i32 %3731, 8388607, !dbg !1096
  %3735 = icmp eq i32 %3734, 0, !dbg !1096
  %is_inf894 = and i1 %3733, %3735, !dbg !1096
  %3736 = and i1 false, %is_inf894, !dbg !1096
  %3737 = bitcast float %2802 to i32, !dbg !1096
  %3738 = and i32 %3737, -2147483648, !dbg !1096
  %3739 = icmp eq i32 -2147483648, %3738, !dbg !1096
  %3740 = and i1 %3736, %3739, !dbg !1096
  %3741 = or i1 %3730, %3740, !dbg !1096
  br i1 %3741, label %3742, label %3744, !dbg !1096

3742:                                             ; preds = %3721
  %3743 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3744, !dbg !1096

3744:                                             ; preds = %3721, %3742
  %3745 = fsub float -0.000000e+00, %2802, !dbg !1096
  %3746 = bitcast float %2802 to i32, !dbg !1096
  %3747 = and i32 %3746, 2139095040, !dbg !1096
  %is_finite895 = icmp ne i32 %3747, 2139095040, !dbg !1096
  %3748 = and i1 true, %is_finite895, !dbg !1096
  %3749 = bitcast float %3745 to i32, !dbg !1096
  %3750 = and i32 %3749, 2139095040, !dbg !1096
  %3751 = icmp eq i32 %3750, 2139095040, !dbg !1096
  %3752 = and i32 %3749, 8388607, !dbg !1096
  %3753 = icmp eq i32 %3752, 0, !dbg !1096
  %is_inf896 = and i1 %3751, %3753, !dbg !1096
  %3754 = bitcast float %3745 to i32, !dbg !1096
  %3755 = and i32 %3754, 2147483647, !dbg !1096
  %is_maxfinite897 = icmp eq i32 %3755, 2139095039, !dbg !1096
  %3756 = bitcast float %3745 to i32, !dbg !1096
  %3757 = and i32 %3756, -2147483648, !dbg !1096
  %3758 = icmp eq i32 %3757, 0, !dbg !1096
  %3759 = icmp ne i32 %3757, 0, !dbg !1096
  %is_pos_inf898 = and i1 %is_inf896, %3758, !dbg !1096
  %is_neg_inf899 = and i1 %is_inf896, %3759, !dbg !1096
  %is_pos_max900 = and i1 %is_maxfinite897, %3758, !dbg !1096
  %is_neg_max901 = and i1 %is_maxfinite897, %3759, !dbg !1096
  %overflow_cond902 = and i1 %3748, %is_inf896, !dbg !1096
  br i1 %overflow_cond902, label %3760, label %3762, !dbg !1096

3760:                                             ; preds = %3744
  %3761 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3762, !dbg !1096

3762:                                             ; preds = %3744, %3760
  %3763 = bitcast float %2802 to i32, !dbg !1096
  %3764 = and i32 %3763, 2139095040, !dbg !1096
  %3765 = icmp eq i32 %3764, 0, !dbg !1096
  %3766 = and i32 %3763, 8388607, !dbg !1096
  %3767 = icmp ne i32 %3766, 0, !dbg !1096
  %is_subnormal903 = and i1 %3765, %3767, !dbg !1096
  %3768 = xor i1 %is_subnormal903, true, !dbg !1096
  %3769 = and i1 true, %3768, !dbg !1096
  %3770 = bitcast float %3745 to i32, !dbg !1096
  %3771 = and i32 %3770, 2139095040, !dbg !1096
  %3772 = icmp eq i32 %3771, 0, !dbg !1096
  %3773 = and i32 %3770, 8388607, !dbg !1096
  %3774 = icmp ne i32 %3773, 0, !dbg !1096
  %is_subnormal904 = and i1 %3772, %3774, !dbg !1096
  %subnormal_cond905 = and i1 %3769, %is_subnormal904, !dbg !1096
  br i1 %subnormal_cond905, label %3775, label %3777, !dbg !1096

3775:                                             ; preds = %3762
  %3776 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3777, !dbg !1096

3777:                                             ; preds = %3762, %3775
  %3778 = bitcast float %3679 to i32, !dbg !1096
  %3779 = bitcast float %3679 to i32, !dbg !1096
  %3780 = and i32 %3779, 2139095040, !dbg !1096
  %3781 = icmp eq i32 %3780, 2139095040, !dbg !1096
  %3782 = and i32 %3779, 8388607, !dbg !1096
  %3783 = icmp ne i32 %3782, 0, !dbg !1096
  %is_nan906 = and i1 %3781, %3783, !dbg !1096
  %3784 = and i32 %3778, 4194304, !dbg !1096
  %3785 = icmp eq i32 %3784, 0, !dbg !1096
  %is_snan907 = and i1 %is_nan906, %3785, !dbg !1096
  %3786 = bitcast float %3745 to i32, !dbg !1096
  %3787 = bitcast float %3745 to i32, !dbg !1096
  %3788 = and i32 %3787, 2139095040, !dbg !1096
  %3789 = icmp eq i32 %3788, 2139095040, !dbg !1096
  %3790 = and i32 %3787, 8388607, !dbg !1096
  %3791 = icmp ne i32 %3790, 0, !dbg !1096
  %is_nan908 = and i1 %3789, %3791, !dbg !1096
  %3792 = and i32 %3786, 4194304, !dbg !1096
  %3793 = icmp eq i32 %3792, 0, !dbg !1096
  %is_snan909 = and i1 %is_nan908, %3793, !dbg !1096
  %3794 = or i1 %is_snan907, %is_snan909, !dbg !1096
  %3795 = bitcast float %3679 to i32, !dbg !1096
  %3796 = and i32 %3795, 2139095040, !dbg !1096
  %3797 = icmp eq i32 %3796, 2139095040, !dbg !1096
  %3798 = and i32 %3795, 8388607, !dbg !1096
  %3799 = icmp eq i32 %3798, 0, !dbg !1096
  %is_inf910 = and i1 %3797, %3799, !dbg !1096
  %3800 = bitcast float %3745 to i32, !dbg !1096
  %3801 = and i32 %3800, 2139095040, !dbg !1096
  %3802 = icmp eq i32 %3801, 2139095040, !dbg !1096
  %3803 = and i32 %3800, 8388607, !dbg !1096
  %3804 = icmp eq i32 %3803, 0, !dbg !1096
  %is_inf911 = and i1 %3802, %3804, !dbg !1096
  %3805 = and i1 %is_inf910, %is_inf911, !dbg !1096
  %3806 = bitcast float %3679 to i32, !dbg !1096
  %3807 = bitcast float %3745 to i32, !dbg !1096
  %3808 = and i32 %3806, -2147483648, !dbg !1096
  %3809 = and i32 %3807, -2147483648, !dbg !1096
  %3810 = icmp ne i32 %3808, %3809, !dbg !1096
  %3811 = and i1 %3805, %3810, !dbg !1096
  %3812 = or i1 %3794, %3811, !dbg !1096
  br i1 %3812, label %3813, label %3815, !dbg !1096

3813:                                             ; preds = %3777
  %3814 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3815, !dbg !1096

3815:                                             ; preds = %3777, %3813
  %3816 = call float @llvm.nvvm.add.rn.f(float %3679, float %3745) #5, !dbg !1096
  %3817 = bitcast float %3679 to i32, !dbg !1096
  %3818 = and i32 %3817, 2139095040, !dbg !1096
  %is_finite912 = icmp ne i32 %3818, 2139095040, !dbg !1096
  %3819 = and i1 true, %is_finite912, !dbg !1096
  %3820 = bitcast float %3745 to i32, !dbg !1096
  %3821 = and i32 %3820, 2139095040, !dbg !1096
  %is_finite913 = icmp ne i32 %3821, 2139095040, !dbg !1096
  %3822 = and i1 %3819, %is_finite913, !dbg !1096
  %3823 = bitcast float %3816 to i32, !dbg !1096
  %3824 = and i32 %3823, 2139095040, !dbg !1096
  %3825 = icmp eq i32 %3824, 2139095040, !dbg !1096
  %3826 = and i32 %3823, 8388607, !dbg !1096
  %3827 = icmp eq i32 %3826, 0, !dbg !1096
  %is_inf914 = and i1 %3825, %3827, !dbg !1096
  %3828 = bitcast float %3816 to i32, !dbg !1096
  %3829 = and i32 %3828, 2147483647, !dbg !1096
  %is_maxfinite915 = icmp eq i32 %3829, 2139095039, !dbg !1096
  %3830 = bitcast float %3816 to i32, !dbg !1096
  %3831 = and i32 %3830, -2147483648, !dbg !1096
  %3832 = icmp eq i32 %3831, 0, !dbg !1096
  %3833 = icmp ne i32 %3831, 0, !dbg !1096
  %is_pos_inf916 = and i1 %is_inf914, %3832, !dbg !1096
  %is_neg_inf917 = and i1 %is_inf914, %3833, !dbg !1096
  %is_pos_max918 = and i1 %is_maxfinite915, %3832, !dbg !1096
  %is_neg_max919 = and i1 %is_maxfinite915, %3833, !dbg !1096
  %overflow_cond920 = and i1 %3822, %is_inf914, !dbg !1096
  br i1 %overflow_cond920, label %3834, label %3836, !dbg !1096

3834:                                             ; preds = %3815
  %3835 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3836, !dbg !1096

3836:                                             ; preds = %3815, %3834
  %3837 = bitcast float %3679 to i32, !dbg !1096
  %3838 = and i32 %3837, 2139095040, !dbg !1096
  %3839 = icmp eq i32 %3838, 0, !dbg !1096
  %3840 = and i32 %3837, 8388607, !dbg !1096
  %3841 = icmp ne i32 %3840, 0, !dbg !1096
  %is_subnormal921 = and i1 %3839, %3841, !dbg !1096
  %3842 = xor i1 %is_subnormal921, true, !dbg !1096
  %3843 = and i1 true, %3842, !dbg !1096
  %3844 = bitcast float %3745 to i32, !dbg !1096
  %3845 = and i32 %3844, 2139095040, !dbg !1096
  %3846 = icmp eq i32 %3845, 0, !dbg !1096
  %3847 = and i32 %3844, 8388607, !dbg !1096
  %3848 = icmp ne i32 %3847, 0, !dbg !1096
  %is_subnormal922 = and i1 %3846, %3848, !dbg !1096
  %3849 = xor i1 %is_subnormal922, true, !dbg !1096
  %3850 = and i1 %3843, %3849, !dbg !1096
  %3851 = bitcast float %3816 to i32, !dbg !1096
  %3852 = and i32 %3851, 2139095040, !dbg !1096
  %3853 = icmp eq i32 %3852, 0, !dbg !1096
  %3854 = and i32 %3851, 8388607, !dbg !1096
  %3855 = icmp ne i32 %3854, 0, !dbg !1096
  %is_subnormal923 = and i1 %3853, %3855, !dbg !1096
  %subnormal_cond924 = and i1 %3850, %is_subnormal923, !dbg !1096
  br i1 %subnormal_cond924, label %3856, label %3858, !dbg !1096

3856:                                             ; preds = %3836
  %3857 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3858, !dbg !1096

3858:                                             ; preds = %3836, %3856
  %3859 = bitcast float %3816 to i32, !dbg !1096
  %3860 = bitcast float %3816 to i32, !dbg !1096
  %3861 = and i32 %3860, 2139095040, !dbg !1096
  %3862 = icmp eq i32 %3861, 2139095040, !dbg !1096
  %3863 = and i32 %3860, 8388607, !dbg !1096
  %3864 = icmp ne i32 %3863, 0, !dbg !1096
  %is_nan925 = and i1 %3862, %3864, !dbg !1096
  %3865 = and i32 %3859, 4194304, !dbg !1096
  %3866 = icmp eq i32 %3865, 0, !dbg !1096
  %is_snan926 = and i1 %is_nan925, %3866, !dbg !1096
  %3867 = or i1 false, %is_snan926, !dbg !1096
  %3868 = bitcast float %3816 to i32, !dbg !1096
  %3869 = and i32 %3868, 2139095040, !dbg !1096
  %3870 = icmp eq i32 %3869, 2139095040, !dbg !1096
  %3871 = and i32 %3868, 8388607, !dbg !1096
  %3872 = icmp eq i32 %3871, 0, !dbg !1096
  %is_inf927 = and i1 %3870, %3872, !dbg !1096
  %3873 = and i1 false, %is_inf927, !dbg !1096
  %3874 = bitcast float %3816 to i32, !dbg !1096
  %3875 = and i32 %3874, -2147483648, !dbg !1096
  %3876 = icmp eq i32 -2147483648, %3875, !dbg !1096
  %3877 = and i1 %3873, %3876, !dbg !1096
  %3878 = or i1 %3867, %3877, !dbg !1096
  br i1 %3878, label %3879, label %3881, !dbg !1096

3879:                                             ; preds = %3858
  %3880 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3881, !dbg !1096

3881:                                             ; preds = %3858, %3879
  %3882 = fsub float -0.000000e+00, %3816, !dbg !1096
  %3883 = bitcast float %3816 to i32, !dbg !1096
  %3884 = and i32 %3883, 2139095040, !dbg !1096
  %is_finite928 = icmp ne i32 %3884, 2139095040, !dbg !1096
  %3885 = and i1 true, %is_finite928, !dbg !1096
  %3886 = bitcast float %3882 to i32, !dbg !1096
  %3887 = and i32 %3886, 2139095040, !dbg !1096
  %3888 = icmp eq i32 %3887, 2139095040, !dbg !1096
  %3889 = and i32 %3886, 8388607, !dbg !1096
  %3890 = icmp eq i32 %3889, 0, !dbg !1096
  %is_inf929 = and i1 %3888, %3890, !dbg !1096
  %3891 = bitcast float %3882 to i32, !dbg !1096
  %3892 = and i32 %3891, 2147483647, !dbg !1096
  %is_maxfinite930 = icmp eq i32 %3892, 2139095039, !dbg !1096
  %3893 = bitcast float %3882 to i32, !dbg !1096
  %3894 = and i32 %3893, -2147483648, !dbg !1096
  %3895 = icmp eq i32 %3894, 0, !dbg !1096
  %3896 = icmp ne i32 %3894, 0, !dbg !1096
  %is_pos_inf931 = and i1 %is_inf929, %3895, !dbg !1096
  %is_neg_inf932 = and i1 %is_inf929, %3896, !dbg !1096
  %is_pos_max933 = and i1 %is_maxfinite930, %3895, !dbg !1096
  %is_neg_max934 = and i1 %is_maxfinite930, %3896, !dbg !1096
  %overflow_cond935 = and i1 %3885, %is_inf929, !dbg !1096
  br i1 %overflow_cond935, label %3897, label %3899, !dbg !1096

3897:                                             ; preds = %3881
  %3898 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3899, !dbg !1096

3899:                                             ; preds = %3881, %3897
  %3900 = bitcast float %3816 to i32, !dbg !1096
  %3901 = and i32 %3900, 2139095040, !dbg !1096
  %3902 = icmp eq i32 %3901, 0, !dbg !1096
  %3903 = and i32 %3900, 8388607, !dbg !1096
  %3904 = icmp ne i32 %3903, 0, !dbg !1096
  %is_subnormal936 = and i1 %3902, %3904, !dbg !1096
  %3905 = xor i1 %is_subnormal936, true, !dbg !1096
  %3906 = and i1 true, %3905, !dbg !1096
  %3907 = bitcast float %3882 to i32, !dbg !1096
  %3908 = and i32 %3907, 2139095040, !dbg !1096
  %3909 = icmp eq i32 %3908, 0, !dbg !1096
  %3910 = and i32 %3907, 8388607, !dbg !1096
  %3911 = icmp ne i32 %3910, 0, !dbg !1096
  %is_subnormal937 = and i1 %3909, %3911, !dbg !1096
  %subnormal_cond938 = and i1 %3906, %is_subnormal937, !dbg !1096
  br i1 %subnormal_cond938, label %3912, label %3914, !dbg !1096

3912:                                             ; preds = %3899
  %3913 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3914, !dbg !1096

3914:                                             ; preds = %3899, %3912
  %3915 = bitcast float %3548 to i32, !dbg !1096
  %3916 = bitcast float %3548 to i32, !dbg !1096
  %3917 = and i32 %3916, 2139095040, !dbg !1096
  %3918 = icmp eq i32 %3917, 2139095040, !dbg !1096
  %3919 = and i32 %3916, 8388607, !dbg !1096
  %3920 = icmp ne i32 %3919, 0, !dbg !1096
  %is_nan939 = and i1 %3918, %3920, !dbg !1096
  %3921 = and i32 %3915, 4194304, !dbg !1096
  %3922 = icmp eq i32 %3921, 0, !dbg !1096
  %is_snan940 = and i1 %is_nan939, %3922, !dbg !1096
  %3923 = bitcast float %3882 to i32, !dbg !1096
  %3924 = bitcast float %3882 to i32, !dbg !1096
  %3925 = and i32 %3924, 2139095040, !dbg !1096
  %3926 = icmp eq i32 %3925, 2139095040, !dbg !1096
  %3927 = and i32 %3924, 8388607, !dbg !1096
  %3928 = icmp ne i32 %3927, 0, !dbg !1096
  %is_nan941 = and i1 %3926, %3928, !dbg !1096
  %3929 = and i32 %3923, 4194304, !dbg !1096
  %3930 = icmp eq i32 %3929, 0, !dbg !1096
  %is_snan942 = and i1 %is_nan941, %3930, !dbg !1096
  %3931 = or i1 %is_snan940, %is_snan942, !dbg !1096
  %3932 = bitcast float %3548 to i32, !dbg !1096
  %3933 = and i32 %3932, 2139095040, !dbg !1096
  %3934 = icmp eq i32 %3933, 2139095040, !dbg !1096
  %3935 = and i32 %3932, 8388607, !dbg !1096
  %3936 = icmp eq i32 %3935, 0, !dbg !1096
  %is_inf943 = and i1 %3934, %3936, !dbg !1096
  %3937 = bitcast float %3882 to i32, !dbg !1096
  %3938 = and i32 %3937, 2139095040, !dbg !1096
  %3939 = icmp eq i32 %3938, 2139095040, !dbg !1096
  %3940 = and i32 %3937, 8388607, !dbg !1096
  %3941 = icmp eq i32 %3940, 0, !dbg !1096
  %is_inf944 = and i1 %3939, %3941, !dbg !1096
  %3942 = and i1 %is_inf943, %is_inf944, !dbg !1096
  %3943 = bitcast float %3548 to i32, !dbg !1096
  %3944 = bitcast float %3882 to i32, !dbg !1096
  %3945 = and i32 %3943, -2147483648, !dbg !1096
  %3946 = and i32 %3944, -2147483648, !dbg !1096
  %3947 = icmp ne i32 %3945, %3946, !dbg !1096
  %3948 = and i1 %3942, %3947, !dbg !1096
  %3949 = or i1 %3931, %3948, !dbg !1096
  br i1 %3949, label %3950, label %3952, !dbg !1096

3950:                                             ; preds = %3914
  %3951 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %3952, !dbg !1096

3952:                                             ; preds = %3914, %3950
  %3953 = call float @llvm.nvvm.add.rn.f(float %3548, float %3882) #5, !dbg !1096
  %3954 = bitcast float %3548 to i32, !dbg !1096
  %3955 = and i32 %3954, 2139095040, !dbg !1096
  %is_finite945 = icmp ne i32 %3955, 2139095040, !dbg !1096
  %3956 = and i1 true, %is_finite945, !dbg !1096
  %3957 = bitcast float %3882 to i32, !dbg !1096
  %3958 = and i32 %3957, 2139095040, !dbg !1096
  %is_finite946 = icmp ne i32 %3958, 2139095040, !dbg !1096
  %3959 = and i1 %3956, %is_finite946, !dbg !1096
  %3960 = bitcast float %3953 to i32, !dbg !1096
  %3961 = and i32 %3960, 2139095040, !dbg !1096
  %3962 = icmp eq i32 %3961, 2139095040, !dbg !1096
  %3963 = and i32 %3960, 8388607, !dbg !1096
  %3964 = icmp eq i32 %3963, 0, !dbg !1096
  %is_inf947 = and i1 %3962, %3964, !dbg !1096
  %3965 = bitcast float %3953 to i32, !dbg !1096
  %3966 = and i32 %3965, 2147483647, !dbg !1096
  %is_maxfinite948 = icmp eq i32 %3966, 2139095039, !dbg !1096
  %3967 = bitcast float %3953 to i32, !dbg !1096
  %3968 = and i32 %3967, -2147483648, !dbg !1096
  %3969 = icmp eq i32 %3968, 0, !dbg !1096
  %3970 = icmp ne i32 %3968, 0, !dbg !1096
  %is_pos_inf949 = and i1 %is_inf947, %3969, !dbg !1096
  %is_neg_inf950 = and i1 %is_inf947, %3970, !dbg !1096
  %is_pos_max951 = and i1 %is_maxfinite948, %3969, !dbg !1096
  %is_neg_max952 = and i1 %is_maxfinite948, %3970, !dbg !1096
  %overflow_cond953 = and i1 %3959, %is_inf947, !dbg !1096
  br i1 %overflow_cond953, label %3971, label %3973, !dbg !1096

3971:                                             ; preds = %3952
  %3972 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %3973, !dbg !1096

3973:                                             ; preds = %3952, %3971
  %3974 = bitcast float %3548 to i32, !dbg !1096
  %3975 = and i32 %3974, 2139095040, !dbg !1096
  %3976 = icmp eq i32 %3975, 0, !dbg !1096
  %3977 = and i32 %3974, 8388607, !dbg !1096
  %3978 = icmp ne i32 %3977, 0, !dbg !1096
  %is_subnormal954 = and i1 %3976, %3978, !dbg !1096
  %3979 = xor i1 %is_subnormal954, true, !dbg !1096
  %3980 = and i1 true, %3979, !dbg !1096
  %3981 = bitcast float %3882 to i32, !dbg !1096
  %3982 = and i32 %3981, 2139095040, !dbg !1096
  %3983 = icmp eq i32 %3982, 0, !dbg !1096
  %3984 = and i32 %3981, 8388607, !dbg !1096
  %3985 = icmp ne i32 %3984, 0, !dbg !1096
  %is_subnormal955 = and i1 %3983, %3985, !dbg !1096
  %3986 = xor i1 %is_subnormal955, true, !dbg !1096
  %3987 = and i1 %3980, %3986, !dbg !1096
  %3988 = bitcast float %3953 to i32, !dbg !1096
  %3989 = and i32 %3988, 2139095040, !dbg !1096
  %3990 = icmp eq i32 %3989, 0, !dbg !1096
  %3991 = and i32 %3988, 8388607, !dbg !1096
  %3992 = icmp ne i32 %3991, 0, !dbg !1096
  %is_subnormal956 = and i1 %3990, %3992, !dbg !1096
  %subnormal_cond957 = and i1 %3987, %is_subnormal956, !dbg !1096
  br i1 %subnormal_cond957, label %3993, label %3995, !dbg !1096

3993:                                             ; preds = %3973
  %3994 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %3995, !dbg !1096

3995:                                             ; preds = %3973, %3993
  %insert77.i = insertvalue %struct.float2 undef, float %3679, 0, !dbg !1096
  %insert79.i = insertvalue %struct.float2 %insert77.i, float %3953, 1, !dbg !1096
  %insert.i = insertvalue %struct.float2 undef, float %3679, 0, !dbg !1096
  %insert69.i = insertvalue %struct.float2 %insert.i, float %3953, 1, !dbg !1096
  %3996 = bitcast float %3679 to i32, !dbg !1096
  %3997 = bitcast float %3679 to i32, !dbg !1096
  %3998 = and i32 %3997, 2139095040, !dbg !1096
  %3999 = icmp eq i32 %3998, 2139095040, !dbg !1096
  %4000 = and i32 %3997, 8388607, !dbg !1096
  %4001 = icmp ne i32 %4000, 0, !dbg !1096
  %is_nan958 = and i1 %3999, %4001, !dbg !1096
  %4002 = and i32 %3996, 4194304, !dbg !1096
  %4003 = icmp eq i32 %4002, 0, !dbg !1096
  %is_snan959 = and i1 %is_nan958, %4003, !dbg !1096
  %4004 = bitcast float %1010 to i32, !dbg !1096
  %4005 = bitcast float %1010 to i32, !dbg !1096
  %4006 = and i32 %4005, 2139095040, !dbg !1096
  %4007 = icmp eq i32 %4006, 2139095040, !dbg !1096
  %4008 = and i32 %4005, 8388607, !dbg !1096
  %4009 = icmp ne i32 %4008, 0, !dbg !1096
  %is_nan960 = and i1 %4007, %4009, !dbg !1096
  %4010 = and i32 %4004, 4194304, !dbg !1096
  %4011 = icmp eq i32 %4010, 0, !dbg !1096
  %is_snan961 = and i1 %is_nan960, %4011, !dbg !1096
  %4012 = or i1 %is_snan959, %is_snan961, !dbg !1096
  %4013 = bitcast float %3679 to i32, !dbg !1096
  %4014 = and i32 %4013, 2147483647, !dbg !1096
  %is_zero962 = icmp eq i32 %4014, 0, !dbg !1096
  %4015 = bitcast float %1010 to i32, !dbg !1096
  %4016 = and i32 %4015, 2139095040, !dbg !1096
  %4017 = icmp eq i32 %4016, 2139095040, !dbg !1096
  %4018 = and i32 %4015, 8388607, !dbg !1096
  %4019 = icmp eq i32 %4018, 0, !dbg !1096
  %is_inf963 = and i1 %4017, %4019, !dbg !1096
  %4020 = and i1 %is_zero962, %is_inf963, !dbg !1096
  %4021 = bitcast float %3679 to i32, !dbg !1096
  %4022 = and i32 %4021, 2139095040, !dbg !1096
  %4023 = icmp eq i32 %4022, 2139095040, !dbg !1096
  %4024 = and i32 %4021, 8388607, !dbg !1096
  %4025 = icmp eq i32 %4024, 0, !dbg !1096
  %is_inf964 = and i1 %4023, %4025, !dbg !1096
  %4026 = bitcast float %1010 to i32, !dbg !1096
  %4027 = and i32 %4026, 2147483647, !dbg !1096
  %is_zero965 = icmp eq i32 %4027, 0, !dbg !1096
  %4028 = and i1 %is_inf964, %is_zero965, !dbg !1096
  %4029 = or i1 %4020, %4028, !dbg !1096
  %4030 = or i1 %4012, %4029, !dbg !1096
  br i1 %4030, label %4031, label %4033, !dbg !1096

4031:                                             ; preds = %3995
  %4032 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4033, !dbg !1096

4033:                                             ; preds = %3995, %4031
  %4034 = call float @llvm.nvvm.mul.rn.f(float %3679, float %1010) #5, !dbg !1096
  %4035 = bitcast float %3679 to i32, !dbg !1096
  %4036 = and i32 %4035, 2139095040, !dbg !1096
  %is_finite966 = icmp ne i32 %4036, 2139095040, !dbg !1096
  %4037 = and i1 true, %is_finite966, !dbg !1096
  %4038 = bitcast float %1010 to i32, !dbg !1096
  %4039 = and i32 %4038, 2139095040, !dbg !1096
  %is_finite967 = icmp ne i32 %4039, 2139095040, !dbg !1096
  %4040 = and i1 %4037, %is_finite967, !dbg !1096
  %4041 = bitcast float %4034 to i32, !dbg !1096
  %4042 = and i32 %4041, 2139095040, !dbg !1096
  %4043 = icmp eq i32 %4042, 2139095040, !dbg !1096
  %4044 = and i32 %4041, 8388607, !dbg !1096
  %4045 = icmp eq i32 %4044, 0, !dbg !1096
  %is_inf968 = and i1 %4043, %4045, !dbg !1096
  %4046 = bitcast float %4034 to i32, !dbg !1096
  %4047 = and i32 %4046, 2147483647, !dbg !1096
  %is_maxfinite969 = icmp eq i32 %4047, 2139095039, !dbg !1096
  %4048 = bitcast float %4034 to i32, !dbg !1096
  %4049 = and i32 %4048, -2147483648, !dbg !1096
  %4050 = icmp eq i32 %4049, 0, !dbg !1096
  %4051 = icmp ne i32 %4049, 0, !dbg !1096
  %is_pos_inf970 = and i1 %is_inf968, %4050, !dbg !1096
  %is_neg_inf971 = and i1 %is_inf968, %4051, !dbg !1096
  %is_pos_max972 = and i1 %is_maxfinite969, %4050, !dbg !1096
  %is_neg_max973 = and i1 %is_maxfinite969, %4051, !dbg !1096
  %overflow_cond974 = and i1 %4040, %is_inf968, !dbg !1096
  br i1 %overflow_cond974, label %4052, label %4054, !dbg !1096

4052:                                             ; preds = %4033
  %4053 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4054, !dbg !1096

4054:                                             ; preds = %4033, %4052
  %4055 = bitcast float %3679 to i32, !dbg !1096
  %4056 = and i32 %4055, 2139095040, !dbg !1096
  %4057 = icmp eq i32 %4056, 0, !dbg !1096
  %4058 = and i32 %4055, 8388607, !dbg !1096
  %4059 = icmp ne i32 %4058, 0, !dbg !1096
  %is_subnormal975 = and i1 %4057, %4059, !dbg !1096
  %4060 = xor i1 %is_subnormal975, true, !dbg !1096
  %4061 = and i1 true, %4060, !dbg !1096
  %4062 = bitcast float %1010 to i32, !dbg !1096
  %4063 = and i32 %4062, 2139095040, !dbg !1096
  %4064 = icmp eq i32 %4063, 0, !dbg !1096
  %4065 = and i32 %4062, 8388607, !dbg !1096
  %4066 = icmp ne i32 %4065, 0, !dbg !1096
  %is_subnormal976 = and i1 %4064, %4066, !dbg !1096
  %4067 = xor i1 %is_subnormal976, true, !dbg !1096
  %4068 = and i1 %4061, %4067, !dbg !1096
  %4069 = bitcast float %4034 to i32, !dbg !1096
  %4070 = and i32 %4069, 2139095040, !dbg !1096
  %4071 = icmp eq i32 %4070, 0, !dbg !1096
  %4072 = and i32 %4069, 8388607, !dbg !1096
  %4073 = icmp ne i32 %4072, 0, !dbg !1096
  %is_subnormal977 = and i1 %4071, %4073, !dbg !1096
  %4074 = bitcast float %4034 to i32, !dbg !1096
  %4075 = and i32 %4074, 2147483647, !dbg !1096
  %is_zero978 = icmp eq i32 %4075, 0, !dbg !1096
  %4076 = bitcast float %3679 to i32, !dbg !1096
  %4077 = and i32 %4076, 2147483647, !dbg !1096
  %is_zero979 = icmp eq i32 %4077, 0, !dbg !1096
  %4078 = xor i1 %is_zero979, true, !dbg !1096
  %4079 = bitcast float %1010 to i32, !dbg !1096
  %4080 = and i32 %4079, 2147483647, !dbg !1096
  %is_zero980 = icmp eq i32 %4080, 0, !dbg !1096
  %4081 = xor i1 %is_zero980, true, !dbg !1096
  %4082 = and i1 %4078, %4081, !dbg !1096
  %4083 = and i1 %is_zero978, %4082, !dbg !1096
  %is_tiny981 = or i1 %is_subnormal977, %4083, !dbg !1096
  %underflow_cond982 = and i1 %4068, %is_tiny981, !dbg !1096
  br i1 %underflow_cond982, label %4084, label %4086, !dbg !1096

4084:                                             ; preds = %4054
  %4085 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4086, !dbg !1096

4086:                                             ; preds = %4054, %4084
  %4087 = bitcast float %3679 to i32, !dbg !1096
  %4088 = and i32 %4087, 2139095040, !dbg !1096
  %4089 = icmp eq i32 %4088, 0, !dbg !1096
  %4090 = and i32 %4087, 8388607, !dbg !1096
  %4091 = icmp ne i32 %4090, 0, !dbg !1096
  %is_subnormal983 = and i1 %4089, %4091, !dbg !1096
  %4092 = xor i1 %is_subnormal983, true, !dbg !1096
  %4093 = and i1 true, %4092, !dbg !1096
  %4094 = bitcast float %1010 to i32, !dbg !1096
  %4095 = and i32 %4094, 2139095040, !dbg !1096
  %4096 = icmp eq i32 %4095, 0, !dbg !1096
  %4097 = and i32 %4094, 8388607, !dbg !1096
  %4098 = icmp ne i32 %4097, 0, !dbg !1096
  %is_subnormal984 = and i1 %4096, %4098, !dbg !1096
  %4099 = xor i1 %is_subnormal984, true, !dbg !1096
  %4100 = and i1 %4093, %4099, !dbg !1096
  %4101 = bitcast float %4034 to i32, !dbg !1096
  %4102 = and i32 %4101, 2139095040, !dbg !1096
  %4103 = icmp eq i32 %4102, 0, !dbg !1096
  %4104 = and i32 %4101, 8388607, !dbg !1096
  %4105 = icmp ne i32 %4104, 0, !dbg !1096
  %is_subnormal985 = and i1 %4103, %4105, !dbg !1096
  %subnormal_cond986 = and i1 %4100, %is_subnormal985, !dbg !1096
  br i1 %subnormal_cond986, label %4106, label %4108, !dbg !1096

4106:                                             ; preds = %4086
  %4107 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4108, !dbg !1096

4108:                                             ; preds = %4086, %4106
  %4109 = bitcast float %4034 to i32, !dbg !1096
  %4110 = bitcast float %4034 to i32, !dbg !1096
  %4111 = and i32 %4110, 2139095040, !dbg !1096
  %4112 = icmp eq i32 %4111, 2139095040, !dbg !1096
  %4113 = and i32 %4110, 8388607, !dbg !1096
  %4114 = icmp ne i32 %4113, 0, !dbg !1096
  %is_nan987 = and i1 %4112, %4114, !dbg !1096
  %4115 = and i32 %4109, 4194304, !dbg !1096
  %4116 = icmp eq i32 %4115, 0, !dbg !1096
  %is_snan988 = and i1 %is_nan987, %4116, !dbg !1096
  %4117 = or i1 false, %is_snan988, !dbg !1096
  %4118 = bitcast float %4034 to i32, !dbg !1096
  %4119 = and i32 %4118, 2139095040, !dbg !1096
  %4120 = icmp eq i32 %4119, 2139095040, !dbg !1096
  %4121 = and i32 %4118, 8388607, !dbg !1096
  %4122 = icmp eq i32 %4121, 0, !dbg !1096
  %is_inf989 = and i1 %4120, %4122, !dbg !1096
  %4123 = and i1 false, %is_inf989, !dbg !1096
  %4124 = bitcast float %4034 to i32, !dbg !1096
  %4125 = and i32 %4124, -2147483648, !dbg !1096
  %4126 = icmp eq i32 -2147483648, %4125, !dbg !1096
  %4127 = and i1 %4123, %4126, !dbg !1096
  %4128 = or i1 %4117, %4127, !dbg !1096
  br i1 %4128, label %4129, label %4131, !dbg !1096

4129:                                             ; preds = %4108
  %4130 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4131, !dbg !1096

4131:                                             ; preds = %4108, %4129
  %4132 = fsub float -0.000000e+00, %4034, !dbg !1096
  %4133 = bitcast float %4034 to i32, !dbg !1096
  %4134 = and i32 %4133, 2139095040, !dbg !1096
  %is_finite990 = icmp ne i32 %4134, 2139095040, !dbg !1096
  %4135 = and i1 true, %is_finite990, !dbg !1096
  %4136 = bitcast float %4132 to i32, !dbg !1096
  %4137 = and i32 %4136, 2139095040, !dbg !1096
  %4138 = icmp eq i32 %4137, 2139095040, !dbg !1096
  %4139 = and i32 %4136, 8388607, !dbg !1096
  %4140 = icmp eq i32 %4139, 0, !dbg !1096
  %is_inf991 = and i1 %4138, %4140, !dbg !1096
  %4141 = bitcast float %4132 to i32, !dbg !1096
  %4142 = and i32 %4141, 2147483647, !dbg !1096
  %is_maxfinite992 = icmp eq i32 %4142, 2139095039, !dbg !1096
  %4143 = bitcast float %4132 to i32, !dbg !1096
  %4144 = and i32 %4143, -2147483648, !dbg !1096
  %4145 = icmp eq i32 %4144, 0, !dbg !1096
  %4146 = icmp ne i32 %4144, 0, !dbg !1096
  %is_pos_inf993 = and i1 %is_inf991, %4145, !dbg !1096
  %is_neg_inf994 = and i1 %is_inf991, %4146, !dbg !1096
  %is_pos_max995 = and i1 %is_maxfinite992, %4145, !dbg !1096
  %is_neg_max996 = and i1 %is_maxfinite992, %4146, !dbg !1096
  %overflow_cond997 = and i1 %4135, %is_inf991, !dbg !1096
  br i1 %overflow_cond997, label %4147, label %4149, !dbg !1096

4147:                                             ; preds = %4131
  %4148 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4149, !dbg !1096

4149:                                             ; preds = %4131, %4147
  %4150 = bitcast float %4034 to i32, !dbg !1096
  %4151 = and i32 %4150, 2139095040, !dbg !1096
  %4152 = icmp eq i32 %4151, 0, !dbg !1096
  %4153 = and i32 %4150, 8388607, !dbg !1096
  %4154 = icmp ne i32 %4153, 0, !dbg !1096
  %is_subnormal998 = and i1 %4152, %4154, !dbg !1096
  %4155 = xor i1 %is_subnormal998, true, !dbg !1096
  %4156 = and i1 true, %4155, !dbg !1096
  %4157 = bitcast float %4132 to i32, !dbg !1096
  %4158 = and i32 %4157, 2139095040, !dbg !1096
  %4159 = icmp eq i32 %4158, 0, !dbg !1096
  %4160 = and i32 %4157, 8388607, !dbg !1096
  %4161 = icmp ne i32 %4160, 0, !dbg !1096
  %is_subnormal999 = and i1 %4159, %4161, !dbg !1096
  %subnormal_cond1000 = and i1 %4156, %is_subnormal999, !dbg !1096
  br i1 %subnormal_cond1000, label %4162, label %4164, !dbg !1096

4162:                                             ; preds = %4149
  %4163 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4164, !dbg !1096

4164:                                             ; preds = %4149, %4162
  %4165 = bitcast float %3679 to i32, !dbg !1096
  %4166 = bitcast float %3679 to i32, !dbg !1096
  %4167 = and i32 %4166, 2139095040, !dbg !1096
  %4168 = icmp eq i32 %4167, 2139095040, !dbg !1096
  %4169 = and i32 %4166, 8388607, !dbg !1096
  %4170 = icmp ne i32 %4169, 0, !dbg !1096
  %is_nan1001 = and i1 %4168, %4170, !dbg !1096
  %4171 = and i32 %4165, 4194304, !dbg !1096
  %4172 = icmp eq i32 %4171, 0, !dbg !1096
  %is_snan1002 = and i1 %is_nan1001, %4172, !dbg !1096
  %4173 = bitcast float %1010 to i32, !dbg !1096
  %4174 = bitcast float %1010 to i32, !dbg !1096
  %4175 = and i32 %4174, 2139095040, !dbg !1096
  %4176 = icmp eq i32 %4175, 2139095040, !dbg !1096
  %4177 = and i32 %4174, 8388607, !dbg !1096
  %4178 = icmp ne i32 %4177, 0, !dbg !1096
  %is_nan1003 = and i1 %4176, %4178, !dbg !1096
  %4179 = and i32 %4173, 4194304, !dbg !1096
  %4180 = icmp eq i32 %4179, 0, !dbg !1096
  %is_snan1004 = and i1 %is_nan1003, %4180, !dbg !1096
  %4181 = or i1 %is_snan1002, %is_snan1004, !dbg !1096
  %4182 = bitcast float %4132 to i32, !dbg !1096
  %4183 = bitcast float %4132 to i32, !dbg !1096
  %4184 = and i32 %4183, 2139095040, !dbg !1096
  %4185 = icmp eq i32 %4184, 2139095040, !dbg !1096
  %4186 = and i32 %4183, 8388607, !dbg !1096
  %4187 = icmp ne i32 %4186, 0, !dbg !1096
  %is_nan1005 = and i1 %4185, %4187, !dbg !1096
  %4188 = and i32 %4182, 4194304, !dbg !1096
  %4189 = icmp eq i32 %4188, 0, !dbg !1096
  %is_snan1006 = and i1 %is_nan1005, %4189, !dbg !1096
  %4190 = or i1 %4181, %is_snan1006, !dbg !1096
  %4191 = bitcast float %3679 to i32, !dbg !1096
  %4192 = and i32 %4191, 2147483647, !dbg !1096
  %is_zero1007 = icmp eq i32 %4192, 0, !dbg !1096
  %4193 = bitcast float %1010 to i32, !dbg !1096
  %4194 = and i32 %4193, 2139095040, !dbg !1096
  %4195 = icmp eq i32 %4194, 2139095040, !dbg !1096
  %4196 = and i32 %4193, 8388607, !dbg !1096
  %4197 = icmp eq i32 %4196, 0, !dbg !1096
  %is_inf1008 = and i1 %4195, %4197, !dbg !1096
  %4198 = and i1 %is_zero1007, %is_inf1008, !dbg !1096
  %4199 = bitcast float %3679 to i32, !dbg !1096
  %4200 = and i32 %4199, 2139095040, !dbg !1096
  %4201 = icmp eq i32 %4200, 2139095040, !dbg !1096
  %4202 = and i32 %4199, 8388607, !dbg !1096
  %4203 = icmp eq i32 %4202, 0, !dbg !1096
  %is_inf1009 = and i1 %4201, %4203, !dbg !1096
  %4204 = bitcast float %1010 to i32, !dbg !1096
  %4205 = and i32 %4204, 2147483647, !dbg !1096
  %is_zero1010 = icmp eq i32 %4205, 0, !dbg !1096
  %4206 = and i1 %is_inf1009, %is_zero1010, !dbg !1096
  %4207 = or i1 %4198, %4206, !dbg !1096
  %4208 = or i1 %4190, %4207, !dbg !1096
  br i1 %4208, label %4209, label %4211, !dbg !1096

4209:                                             ; preds = %4164
  %4210 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4211, !dbg !1096

4211:                                             ; preds = %4164, %4209
  %4212 = call float @llvm.nvvm.fma.rn.f(float %3679, float %1010, float %4132) #5, !dbg !1096
  %4213 = bitcast float %3679 to i32, !dbg !1096
  %4214 = and i32 %4213, 2139095040, !dbg !1096
  %is_finite1011 = icmp ne i32 %4214, 2139095040, !dbg !1096
  %4215 = and i1 true, %is_finite1011, !dbg !1096
  %4216 = bitcast float %1010 to i32, !dbg !1096
  %4217 = and i32 %4216, 2139095040, !dbg !1096
  %is_finite1012 = icmp ne i32 %4217, 2139095040, !dbg !1096
  %4218 = and i1 %4215, %is_finite1012, !dbg !1096
  %4219 = bitcast float %4212 to i32, !dbg !1096
  %4220 = and i32 %4219, 2139095040, !dbg !1096
  %4221 = icmp eq i32 %4220, 2139095040, !dbg !1096
  %4222 = and i32 %4219, 8388607, !dbg !1096
  %4223 = icmp eq i32 %4222, 0, !dbg !1096
  %is_inf1013 = and i1 %4221, %4223, !dbg !1096
  %4224 = bitcast float %4212 to i32, !dbg !1096
  %4225 = and i32 %4224, 2147483647, !dbg !1096
  %is_maxfinite1014 = icmp eq i32 %4225, 2139095039, !dbg !1096
  %4226 = bitcast float %4212 to i32, !dbg !1096
  %4227 = and i32 %4226, -2147483648, !dbg !1096
  %4228 = icmp eq i32 %4227, 0, !dbg !1096
  %4229 = icmp ne i32 %4227, 0, !dbg !1096
  %is_pos_inf1015 = and i1 %is_inf1013, %4228, !dbg !1096
  %is_neg_inf1016 = and i1 %is_inf1013, %4229, !dbg !1096
  %is_pos_max1017 = and i1 %is_maxfinite1014, %4228, !dbg !1096
  %is_neg_max1018 = and i1 %is_maxfinite1014, %4229, !dbg !1096
  %overflow_cond1019 = and i1 %4218, %is_inf1013, !dbg !1096
  br i1 %overflow_cond1019, label %4230, label %4232, !dbg !1096

4230:                                             ; preds = %4211
  %4231 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4232, !dbg !1096

4232:                                             ; preds = %4211, %4230
  %4233 = bitcast float %3679 to i32, !dbg !1096
  %4234 = and i32 %4233, 2139095040, !dbg !1096
  %4235 = icmp eq i32 %4234, 0, !dbg !1096
  %4236 = and i32 %4233, 8388607, !dbg !1096
  %4237 = icmp ne i32 %4236, 0, !dbg !1096
  %is_subnormal1020 = and i1 %4235, %4237, !dbg !1096
  %4238 = xor i1 %is_subnormal1020, true, !dbg !1096
  %4239 = and i1 true, %4238, !dbg !1096
  %4240 = bitcast float %1010 to i32, !dbg !1096
  %4241 = and i32 %4240, 2139095040, !dbg !1096
  %4242 = icmp eq i32 %4241, 0, !dbg !1096
  %4243 = and i32 %4240, 8388607, !dbg !1096
  %4244 = icmp ne i32 %4243, 0, !dbg !1096
  %is_subnormal1021 = and i1 %4242, %4244, !dbg !1096
  %4245 = xor i1 %is_subnormal1021, true, !dbg !1096
  %4246 = and i1 %4239, %4245, !dbg !1096
  %4247 = bitcast float %4132 to i32, !dbg !1096
  %4248 = and i32 %4247, 2139095040, !dbg !1096
  %4249 = icmp eq i32 %4248, 0, !dbg !1096
  %4250 = and i32 %4247, 8388607, !dbg !1096
  %4251 = icmp ne i32 %4250, 0, !dbg !1096
  %is_subnormal1022 = and i1 %4249, %4251, !dbg !1096
  %4252 = xor i1 %is_subnormal1022, true, !dbg !1096
  %4253 = and i1 %4246, %4252, !dbg !1096
  %4254 = bitcast float %4212 to i32, !dbg !1096
  %4255 = and i32 %4254, 2139095040, !dbg !1096
  %4256 = icmp eq i32 %4255, 0, !dbg !1096
  %4257 = and i32 %4254, 8388607, !dbg !1096
  %4258 = icmp ne i32 %4257, 0, !dbg !1096
  %is_subnormal1023 = and i1 %4256, %4258, !dbg !1096
  %4259 = bitcast float %4212 to i32, !dbg !1096
  %4260 = and i32 %4259, 2147483647, !dbg !1096
  %is_zero1024 = icmp eq i32 %4260, 0, !dbg !1096
  %4261 = bitcast float %3679 to i32, !dbg !1096
  %4262 = and i32 %4261, 2147483647, !dbg !1096
  %is_zero1025 = icmp eq i32 %4262, 0, !dbg !1096
  %4263 = xor i1 %is_zero1025, true, !dbg !1096
  %4264 = bitcast float %1010 to i32, !dbg !1096
  %4265 = and i32 %4264, 2147483647, !dbg !1096
  %is_zero1026 = icmp eq i32 %4265, 0, !dbg !1096
  %4266 = xor i1 %is_zero1026, true, !dbg !1096
  %4267 = bitcast float %4132 to i32, !dbg !1096
  %4268 = and i32 %4267, 2147483647, !dbg !1096
  %is_zero1027 = icmp eq i32 %4268, 0, !dbg !1096
  %4269 = xor i1 %is_zero1027, true, !dbg !1096
  %4270 = and i1 %4263, %4266, !dbg !1096
  %4271 = and i1 %4270, %4269, !dbg !1096
  %4272 = and i1 %is_zero1024, %4271, !dbg !1096
  %is_tiny1028 = or i1 %is_subnormal1023, %4272, !dbg !1096
  %underflow_cond1029 = and i1 %4253, %is_tiny1028, !dbg !1096
  br i1 %underflow_cond1029, label %4273, label %4275, !dbg !1096

4273:                                             ; preds = %4232
  %4274 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4275, !dbg !1096

4275:                                             ; preds = %4232, %4273
  %4276 = bitcast float %3679 to i32, !dbg !1096
  %4277 = and i32 %4276, 2139095040, !dbg !1096
  %4278 = icmp eq i32 %4277, 0, !dbg !1096
  %4279 = and i32 %4276, 8388607, !dbg !1096
  %4280 = icmp ne i32 %4279, 0, !dbg !1096
  %is_subnormal1030 = and i1 %4278, %4280, !dbg !1096
  %4281 = xor i1 %is_subnormal1030, true, !dbg !1096
  %4282 = and i1 true, %4281, !dbg !1096
  %4283 = bitcast float %1010 to i32, !dbg !1096
  %4284 = and i32 %4283, 2139095040, !dbg !1096
  %4285 = icmp eq i32 %4284, 0, !dbg !1096
  %4286 = and i32 %4283, 8388607, !dbg !1096
  %4287 = icmp ne i32 %4286, 0, !dbg !1096
  %is_subnormal1031 = and i1 %4285, %4287, !dbg !1096
  %4288 = xor i1 %is_subnormal1031, true, !dbg !1096
  %4289 = and i1 %4282, %4288, !dbg !1096
  %4290 = bitcast float %4132 to i32, !dbg !1096
  %4291 = and i32 %4290, 2139095040, !dbg !1096
  %4292 = icmp eq i32 %4291, 0, !dbg !1096
  %4293 = and i32 %4290, 8388607, !dbg !1096
  %4294 = icmp ne i32 %4293, 0, !dbg !1096
  %is_subnormal1032 = and i1 %4292, %4294, !dbg !1096
  %4295 = xor i1 %is_subnormal1032, true, !dbg !1096
  %4296 = and i1 %4289, %4295, !dbg !1096
  %4297 = bitcast float %4212 to i32, !dbg !1096
  %4298 = and i32 %4297, 2139095040, !dbg !1096
  %4299 = icmp eq i32 %4298, 0, !dbg !1096
  %4300 = and i32 %4297, 8388607, !dbg !1096
  %4301 = icmp ne i32 %4300, 0, !dbg !1096
  %is_subnormal1033 = and i1 %4299, %4301, !dbg !1096
  %subnormal_cond1034 = and i1 %4296, %is_subnormal1033, !dbg !1096
  br i1 %subnormal_cond1034, label %4302, label %4304, !dbg !1096

4302:                                             ; preds = %4275
  %4303 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4304, !dbg !1096

4304:                                             ; preds = %4275, %4302
  %insert97.i = insertvalue %struct.float2 undef, float %4034, 0, !dbg !1096
  %insert99.i = insertvalue %struct.float2 %insert97.i, float %4212, 1, !dbg !1096
  %4305 = bitcast float %3953 to i32, !dbg !1096
  %4306 = bitcast float %3953 to i32, !dbg !1096
  %4307 = and i32 %4306, 2139095040, !dbg !1096
  %4308 = icmp eq i32 %4307, 2139095040, !dbg !1096
  %4309 = and i32 %4306, 8388607, !dbg !1096
  %4310 = icmp ne i32 %4309, 0, !dbg !1096
  %is_nan1035 = and i1 %4308, %4310, !dbg !1096
  %4311 = and i32 %4305, 4194304, !dbg !1096
  %4312 = icmp eq i32 %4311, 0, !dbg !1096
  %is_snan1036 = and i1 %is_nan1035, %4312, !dbg !1096
  %4313 = bitcast float %1010 to i32, !dbg !1096
  %4314 = bitcast float %1010 to i32, !dbg !1096
  %4315 = and i32 %4314, 2139095040, !dbg !1096
  %4316 = icmp eq i32 %4315, 2139095040, !dbg !1096
  %4317 = and i32 %4314, 8388607, !dbg !1096
  %4318 = icmp ne i32 %4317, 0, !dbg !1096
  %is_nan1037 = and i1 %4316, %4318, !dbg !1096
  %4319 = and i32 %4313, 4194304, !dbg !1096
  %4320 = icmp eq i32 %4319, 0, !dbg !1096
  %is_snan1038 = and i1 %is_nan1037, %4320, !dbg !1096
  %4321 = or i1 %is_snan1036, %is_snan1038, !dbg !1096
  %4322 = bitcast float %4212 to i32, !dbg !1096
  %4323 = bitcast float %4212 to i32, !dbg !1096
  %4324 = and i32 %4323, 2139095040, !dbg !1096
  %4325 = icmp eq i32 %4324, 2139095040, !dbg !1096
  %4326 = and i32 %4323, 8388607, !dbg !1096
  %4327 = icmp ne i32 %4326, 0, !dbg !1096
  %is_nan1039 = and i1 %4325, %4327, !dbg !1096
  %4328 = and i32 %4322, 4194304, !dbg !1096
  %4329 = icmp eq i32 %4328, 0, !dbg !1096
  %is_snan1040 = and i1 %is_nan1039, %4329, !dbg !1096
  %4330 = or i1 %4321, %is_snan1040, !dbg !1096
  %4331 = bitcast float %3953 to i32, !dbg !1096
  %4332 = and i32 %4331, 2147483647, !dbg !1096
  %is_zero1041 = icmp eq i32 %4332, 0, !dbg !1096
  %4333 = bitcast float %1010 to i32, !dbg !1096
  %4334 = and i32 %4333, 2139095040, !dbg !1096
  %4335 = icmp eq i32 %4334, 2139095040, !dbg !1096
  %4336 = and i32 %4333, 8388607, !dbg !1096
  %4337 = icmp eq i32 %4336, 0, !dbg !1096
  %is_inf1042 = and i1 %4335, %4337, !dbg !1096
  %4338 = and i1 %is_zero1041, %is_inf1042, !dbg !1096
  %4339 = bitcast float %3953 to i32, !dbg !1096
  %4340 = and i32 %4339, 2139095040, !dbg !1096
  %4341 = icmp eq i32 %4340, 2139095040, !dbg !1096
  %4342 = and i32 %4339, 8388607, !dbg !1096
  %4343 = icmp eq i32 %4342, 0, !dbg !1096
  %is_inf1043 = and i1 %4341, %4343, !dbg !1096
  %4344 = bitcast float %1010 to i32, !dbg !1096
  %4345 = and i32 %4344, 2147483647, !dbg !1096
  %is_zero1044 = icmp eq i32 %4345, 0, !dbg !1096
  %4346 = and i1 %is_inf1043, %is_zero1044, !dbg !1096
  %4347 = or i1 %4338, %4346, !dbg !1096
  %4348 = or i1 %4330, %4347, !dbg !1096
  br i1 %4348, label %4349, label %4351, !dbg !1096

4349:                                             ; preds = %4304
  %4350 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4351, !dbg !1096

4351:                                             ; preds = %4304, %4349
  %4352 = call float @llvm.nvvm.fma.rn.f(float %3953, float %1010, float %4212) #5, !dbg !1096
  %4353 = bitcast float %3953 to i32, !dbg !1096
  %4354 = and i32 %4353, 2139095040, !dbg !1096
  %is_finite1045 = icmp ne i32 %4354, 2139095040, !dbg !1096
  %4355 = and i1 true, %is_finite1045, !dbg !1096
  %4356 = bitcast float %1010 to i32, !dbg !1096
  %4357 = and i32 %4356, 2139095040, !dbg !1096
  %is_finite1046 = icmp ne i32 %4357, 2139095040, !dbg !1096
  %4358 = and i1 %4355, %is_finite1046, !dbg !1096
  %4359 = bitcast float %4352 to i32, !dbg !1096
  %4360 = and i32 %4359, 2139095040, !dbg !1096
  %4361 = icmp eq i32 %4360, 2139095040, !dbg !1096
  %4362 = and i32 %4359, 8388607, !dbg !1096
  %4363 = icmp eq i32 %4362, 0, !dbg !1096
  %is_inf1047 = and i1 %4361, %4363, !dbg !1096
  %4364 = bitcast float %4352 to i32, !dbg !1096
  %4365 = and i32 %4364, 2147483647, !dbg !1096
  %is_maxfinite1048 = icmp eq i32 %4365, 2139095039, !dbg !1096
  %4366 = bitcast float %4352 to i32, !dbg !1096
  %4367 = and i32 %4366, -2147483648, !dbg !1096
  %4368 = icmp eq i32 %4367, 0, !dbg !1096
  %4369 = icmp ne i32 %4367, 0, !dbg !1096
  %is_pos_inf1049 = and i1 %is_inf1047, %4368, !dbg !1096
  %is_neg_inf1050 = and i1 %is_inf1047, %4369, !dbg !1096
  %is_pos_max1051 = and i1 %is_maxfinite1048, %4368, !dbg !1096
  %is_neg_max1052 = and i1 %is_maxfinite1048, %4369, !dbg !1096
  %overflow_cond1053 = and i1 %4358, %is_inf1047, !dbg !1096
  br i1 %overflow_cond1053, label %4370, label %4372, !dbg !1096

4370:                                             ; preds = %4351
  %4371 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4372, !dbg !1096

4372:                                             ; preds = %4351, %4370
  %4373 = bitcast float %3953 to i32, !dbg !1096
  %4374 = and i32 %4373, 2139095040, !dbg !1096
  %4375 = icmp eq i32 %4374, 0, !dbg !1096
  %4376 = and i32 %4373, 8388607, !dbg !1096
  %4377 = icmp ne i32 %4376, 0, !dbg !1096
  %is_subnormal1054 = and i1 %4375, %4377, !dbg !1096
  %4378 = xor i1 %is_subnormal1054, true, !dbg !1096
  %4379 = and i1 true, %4378, !dbg !1096
  %4380 = bitcast float %1010 to i32, !dbg !1096
  %4381 = and i32 %4380, 2139095040, !dbg !1096
  %4382 = icmp eq i32 %4381, 0, !dbg !1096
  %4383 = and i32 %4380, 8388607, !dbg !1096
  %4384 = icmp ne i32 %4383, 0, !dbg !1096
  %is_subnormal1055 = and i1 %4382, %4384, !dbg !1096
  %4385 = xor i1 %is_subnormal1055, true, !dbg !1096
  %4386 = and i1 %4379, %4385, !dbg !1096
  %4387 = bitcast float %4212 to i32, !dbg !1096
  %4388 = and i32 %4387, 2139095040, !dbg !1096
  %4389 = icmp eq i32 %4388, 0, !dbg !1096
  %4390 = and i32 %4387, 8388607, !dbg !1096
  %4391 = icmp ne i32 %4390, 0, !dbg !1096
  %is_subnormal1056 = and i1 %4389, %4391, !dbg !1096
  %4392 = xor i1 %is_subnormal1056, true, !dbg !1096
  %4393 = and i1 %4386, %4392, !dbg !1096
  %4394 = bitcast float %4352 to i32, !dbg !1096
  %4395 = and i32 %4394, 2139095040, !dbg !1096
  %4396 = icmp eq i32 %4395, 0, !dbg !1096
  %4397 = and i32 %4394, 8388607, !dbg !1096
  %4398 = icmp ne i32 %4397, 0, !dbg !1096
  %is_subnormal1057 = and i1 %4396, %4398, !dbg !1096
  %4399 = bitcast float %4352 to i32, !dbg !1096
  %4400 = and i32 %4399, 2147483647, !dbg !1096
  %is_zero1058 = icmp eq i32 %4400, 0, !dbg !1096
  %4401 = bitcast float %3953 to i32, !dbg !1096
  %4402 = and i32 %4401, 2147483647, !dbg !1096
  %is_zero1059 = icmp eq i32 %4402, 0, !dbg !1096
  %4403 = xor i1 %is_zero1059, true, !dbg !1096
  %4404 = bitcast float %1010 to i32, !dbg !1096
  %4405 = and i32 %4404, 2147483647, !dbg !1096
  %is_zero1060 = icmp eq i32 %4405, 0, !dbg !1096
  %4406 = xor i1 %is_zero1060, true, !dbg !1096
  %4407 = bitcast float %4212 to i32, !dbg !1096
  %4408 = and i32 %4407, 2147483647, !dbg !1096
  %is_zero1061 = icmp eq i32 %4408, 0, !dbg !1096
  %4409 = xor i1 %is_zero1061, true, !dbg !1096
  %4410 = and i1 %4403, %4406, !dbg !1096
  %4411 = and i1 %4410, %4409, !dbg !1096
  %4412 = and i1 %is_zero1058, %4411, !dbg !1096
  %is_tiny1062 = or i1 %is_subnormal1057, %4412, !dbg !1096
  %underflow_cond1063 = and i1 %4393, %is_tiny1062, !dbg !1096
  br i1 %underflow_cond1063, label %4413, label %4415, !dbg !1096

4413:                                             ; preds = %4372
  %4414 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4415, !dbg !1096

4415:                                             ; preds = %4372, %4413
  %4416 = bitcast float %3953 to i32, !dbg !1096
  %4417 = and i32 %4416, 2139095040, !dbg !1096
  %4418 = icmp eq i32 %4417, 0, !dbg !1096
  %4419 = and i32 %4416, 8388607, !dbg !1096
  %4420 = icmp ne i32 %4419, 0, !dbg !1096
  %is_subnormal1064 = and i1 %4418, %4420, !dbg !1096
  %4421 = xor i1 %is_subnormal1064, true, !dbg !1096
  %4422 = and i1 true, %4421, !dbg !1096
  %4423 = bitcast float %1010 to i32, !dbg !1096
  %4424 = and i32 %4423, 2139095040, !dbg !1096
  %4425 = icmp eq i32 %4424, 0, !dbg !1096
  %4426 = and i32 %4423, 8388607, !dbg !1096
  %4427 = icmp ne i32 %4426, 0, !dbg !1096
  %is_subnormal1065 = and i1 %4425, %4427, !dbg !1096
  %4428 = xor i1 %is_subnormal1065, true, !dbg !1096
  %4429 = and i1 %4422, %4428, !dbg !1096
  %4430 = bitcast float %4212 to i32, !dbg !1096
  %4431 = and i32 %4430, 2139095040, !dbg !1096
  %4432 = icmp eq i32 %4431, 0, !dbg !1096
  %4433 = and i32 %4430, 8388607, !dbg !1096
  %4434 = icmp ne i32 %4433, 0, !dbg !1096
  %is_subnormal1066 = and i1 %4432, %4434, !dbg !1096
  %4435 = xor i1 %is_subnormal1066, true, !dbg !1096
  %4436 = and i1 %4429, %4435, !dbg !1096
  %4437 = bitcast float %4352 to i32, !dbg !1096
  %4438 = and i32 %4437, 2139095040, !dbg !1096
  %4439 = icmp eq i32 %4438, 0, !dbg !1096
  %4440 = and i32 %4437, 8388607, !dbg !1096
  %4441 = icmp ne i32 %4440, 0, !dbg !1096
  %is_subnormal1067 = and i1 %4439, %4441, !dbg !1096
  %subnormal_cond1068 = and i1 %4436, %is_subnormal1067, !dbg !1096
  br i1 %subnormal_cond1068, label %4442, label %4444, !dbg !1096

4442:                                             ; preds = %4415
  %4443 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4444, !dbg !1096

4444:                                             ; preds = %4415, %4442
  %4445 = call float @llvm.nvvm.round.f(float %4034) #5, !dbg !1096
  %4446 = bitcast float %4034 to i32, !dbg !1096
  %4447 = bitcast float %4034 to i32, !dbg !1096
  %4448 = and i32 %4447, 2139095040, !dbg !1096
  %4449 = icmp eq i32 %4448, 2139095040, !dbg !1096
  %4450 = and i32 %4447, 8388607, !dbg !1096
  %4451 = icmp ne i32 %4450, 0, !dbg !1096
  %is_nan1069 = and i1 %4449, %4451, !dbg !1096
  %4452 = and i32 %4446, 4194304, !dbg !1096
  %4453 = icmp eq i32 %4452, 0, !dbg !1096
  %is_snan1070 = and i1 %is_nan1069, %4453, !dbg !1096
  %4454 = bitcast float %4445 to i32, !dbg !1096
  %4455 = bitcast float %4445 to i32, !dbg !1096
  %4456 = and i32 %4455, 2139095040, !dbg !1096
  %4457 = icmp eq i32 %4456, 2139095040, !dbg !1096
  %4458 = and i32 %4455, 8388607, !dbg !1096
  %4459 = icmp ne i32 %4458, 0, !dbg !1096
  %is_nan1071 = and i1 %4457, %4459, !dbg !1096
  %4460 = and i32 %4454, 4194304, !dbg !1096
  %4461 = icmp eq i32 %4460, 0, !dbg !1096
  %is_snan1072 = and i1 %is_nan1071, %4461, !dbg !1096
  %4462 = or i1 %is_snan1070, %is_snan1072, !dbg !1096
  %4463 = bitcast float %4034 to i32, !dbg !1096
  %4464 = and i32 %4463, 2139095040, !dbg !1096
  %4465 = icmp eq i32 %4464, 2139095040, !dbg !1096
  %4466 = and i32 %4463, 8388607, !dbg !1096
  %4467 = icmp eq i32 %4466, 0, !dbg !1096
  %is_inf1073 = and i1 %4465, %4467, !dbg !1096
  %4468 = bitcast float %4445 to i32, !dbg !1096
  %4469 = and i32 %4468, 2139095040, !dbg !1096
  %4470 = icmp eq i32 %4469, 2139095040, !dbg !1096
  %4471 = and i32 %4468, 8388607, !dbg !1096
  %4472 = icmp eq i32 %4471, 0, !dbg !1096
  %is_inf1074 = and i1 %4470, %4472, !dbg !1096
  %4473 = and i1 %is_inf1073, %is_inf1074, !dbg !1096
  %4474 = bitcast float %4034 to i32, !dbg !1096
  %4475 = bitcast float %4445 to i32, !dbg !1096
  %4476 = and i32 %4474, -2147483648, !dbg !1096
  %4477 = and i32 %4475, -2147483648, !dbg !1096
  %4478 = icmp eq i32 %4476, %4477, !dbg !1096
  %4479 = and i1 %4473, %4478, !dbg !1096
  %4480 = or i1 %4462, %4479, !dbg !1096
  br i1 %4480, label %4481, label %4483, !dbg !1096

4481:                                             ; preds = %4444
  %4482 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4483, !dbg !1096

4483:                                             ; preds = %4444, %4481
  %4484 = fsub float %4034, %4445, !dbg !1096
  %4485 = bitcast float %4034 to i32, !dbg !1096
  %4486 = and i32 %4485, 2139095040, !dbg !1096
  %is_finite1075 = icmp ne i32 %4486, 2139095040, !dbg !1096
  %4487 = and i1 true, %is_finite1075, !dbg !1096
  %4488 = bitcast float %4445 to i32, !dbg !1096
  %4489 = and i32 %4488, 2139095040, !dbg !1096
  %is_finite1076 = icmp ne i32 %4489, 2139095040, !dbg !1096
  %4490 = and i1 %4487, %is_finite1076, !dbg !1096
  %4491 = bitcast float %4484 to i32, !dbg !1096
  %4492 = and i32 %4491, 2139095040, !dbg !1096
  %4493 = icmp eq i32 %4492, 2139095040, !dbg !1096
  %4494 = and i32 %4491, 8388607, !dbg !1096
  %4495 = icmp eq i32 %4494, 0, !dbg !1096
  %is_inf1077 = and i1 %4493, %4495, !dbg !1096
  %4496 = bitcast float %4484 to i32, !dbg !1096
  %4497 = and i32 %4496, 2147483647, !dbg !1096
  %is_maxfinite1078 = icmp eq i32 %4497, 2139095039, !dbg !1096
  %4498 = bitcast float %4484 to i32, !dbg !1096
  %4499 = and i32 %4498, -2147483648, !dbg !1096
  %4500 = icmp eq i32 %4499, 0, !dbg !1096
  %4501 = icmp ne i32 %4499, 0, !dbg !1096
  %is_pos_inf1079 = and i1 %is_inf1077, %4500, !dbg !1096
  %is_neg_inf1080 = and i1 %is_inf1077, %4501, !dbg !1096
  %is_pos_max1081 = and i1 %is_maxfinite1078, %4500, !dbg !1096
  %is_neg_max1082 = and i1 %is_maxfinite1078, %4501, !dbg !1096
  %overflow_cond1083 = and i1 %4490, %is_inf1077, !dbg !1096
  br i1 %overflow_cond1083, label %4502, label %4504, !dbg !1096

4502:                                             ; preds = %4483
  %4503 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4504, !dbg !1096

4504:                                             ; preds = %4483, %4502
  %4505 = bitcast float %4034 to i32, !dbg !1096
  %4506 = and i32 %4505, 2139095040, !dbg !1096
  %4507 = icmp eq i32 %4506, 0, !dbg !1096
  %4508 = and i32 %4505, 8388607, !dbg !1096
  %4509 = icmp ne i32 %4508, 0, !dbg !1096
  %is_subnormal1084 = and i1 %4507, %4509, !dbg !1096
  %4510 = xor i1 %is_subnormal1084, true, !dbg !1096
  %4511 = and i1 true, %4510, !dbg !1096
  %4512 = bitcast float %4445 to i32, !dbg !1096
  %4513 = and i32 %4512, 2139095040, !dbg !1096
  %4514 = icmp eq i32 %4513, 0, !dbg !1096
  %4515 = and i32 %4512, 8388607, !dbg !1096
  %4516 = icmp ne i32 %4515, 0, !dbg !1096
  %is_subnormal1085 = and i1 %4514, %4516, !dbg !1096
  %4517 = xor i1 %is_subnormal1085, true, !dbg !1096
  %4518 = and i1 %4511, %4517, !dbg !1096
  %4519 = bitcast float %4484 to i32, !dbg !1096
  %4520 = and i32 %4519, 2139095040, !dbg !1096
  %4521 = icmp eq i32 %4520, 0, !dbg !1096
  %4522 = and i32 %4519, 8388607, !dbg !1096
  %4523 = icmp ne i32 %4522, 0, !dbg !1096
  %is_subnormal1086 = and i1 %4521, %4523, !dbg !1096
  %subnormal_cond1087 = and i1 %4518, %is_subnormal1086, !dbg !1096
  br i1 %subnormal_cond1087, label %4524, label %4526, !dbg !1096

4524:                                             ; preds = %4504
  %4525 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4526, !dbg !1096

4526:                                             ; preds = %4504, %4524
  %4527 = bitcast float %4484 to i32, !dbg !1096
  %4528 = bitcast float %4484 to i32, !dbg !1096
  %4529 = and i32 %4528, 2139095040, !dbg !1096
  %4530 = icmp eq i32 %4529, 2139095040, !dbg !1096
  %4531 = and i32 %4528, 8388607, !dbg !1096
  %4532 = icmp ne i32 %4531, 0, !dbg !1096
  %is_nan1088 = and i1 %4530, %4532, !dbg !1096
  %4533 = and i32 %4527, 4194304, !dbg !1096
  %4534 = icmp eq i32 %4533, 0, !dbg !1096
  %is_snan1089 = and i1 %is_nan1088, %4534, !dbg !1096
  %4535 = bitcast float %4352 to i32, !dbg !1096
  %4536 = bitcast float %4352 to i32, !dbg !1096
  %4537 = and i32 %4536, 2139095040, !dbg !1096
  %4538 = icmp eq i32 %4537, 2139095040, !dbg !1096
  %4539 = and i32 %4536, 8388607, !dbg !1096
  %4540 = icmp ne i32 %4539, 0, !dbg !1096
  %is_nan1090 = and i1 %4538, %4540, !dbg !1096
  %4541 = and i32 %4535, 4194304, !dbg !1096
  %4542 = icmp eq i32 %4541, 0, !dbg !1096
  %is_snan1091 = and i1 %is_nan1090, %4542, !dbg !1096
  %4543 = or i1 %is_snan1089, %is_snan1091, !dbg !1096
  %4544 = bitcast float %4484 to i32, !dbg !1096
  %4545 = and i32 %4544, 2139095040, !dbg !1096
  %4546 = icmp eq i32 %4545, 2139095040, !dbg !1096
  %4547 = and i32 %4544, 8388607, !dbg !1096
  %4548 = icmp eq i32 %4547, 0, !dbg !1096
  %is_inf1092 = and i1 %4546, %4548, !dbg !1096
  %4549 = bitcast float %4352 to i32, !dbg !1096
  %4550 = and i32 %4549, 2139095040, !dbg !1096
  %4551 = icmp eq i32 %4550, 2139095040, !dbg !1096
  %4552 = and i32 %4549, 8388607, !dbg !1096
  %4553 = icmp eq i32 %4552, 0, !dbg !1096
  %is_inf1093 = and i1 %4551, %4553, !dbg !1096
  %4554 = and i1 %is_inf1092, %is_inf1093, !dbg !1096
  %4555 = bitcast float %4484 to i32, !dbg !1096
  %4556 = bitcast float %4352 to i32, !dbg !1096
  %4557 = and i32 %4555, -2147483648, !dbg !1096
  %4558 = and i32 %4556, -2147483648, !dbg !1096
  %4559 = icmp ne i32 %4557, %4558, !dbg !1096
  %4560 = and i1 %4554, %4559, !dbg !1096
  %4561 = or i1 %4543, %4560, !dbg !1096
  br i1 %4561, label %4562, label %4564, !dbg !1096

4562:                                             ; preds = %4526
  %4563 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4564, !dbg !1096

4564:                                             ; preds = %4526, %4562
  %4565 = fadd float %4484, %4352, !dbg !1096
  %4566 = bitcast float %4484 to i32, !dbg !1096
  %4567 = and i32 %4566, 2139095040, !dbg !1096
  %is_finite1094 = icmp ne i32 %4567, 2139095040, !dbg !1096
  %4568 = and i1 true, %is_finite1094, !dbg !1096
  %4569 = bitcast float %4352 to i32, !dbg !1096
  %4570 = and i32 %4569, 2139095040, !dbg !1096
  %is_finite1095 = icmp ne i32 %4570, 2139095040, !dbg !1096
  %4571 = and i1 %4568, %is_finite1095, !dbg !1096
  %4572 = bitcast float %4565 to i32, !dbg !1096
  %4573 = and i32 %4572, 2139095040, !dbg !1096
  %4574 = icmp eq i32 %4573, 2139095040, !dbg !1096
  %4575 = and i32 %4572, 8388607, !dbg !1096
  %4576 = icmp eq i32 %4575, 0, !dbg !1096
  %is_inf1096 = and i1 %4574, %4576, !dbg !1096
  %4577 = bitcast float %4565 to i32, !dbg !1096
  %4578 = and i32 %4577, 2147483647, !dbg !1096
  %is_maxfinite1097 = icmp eq i32 %4578, 2139095039, !dbg !1096
  %4579 = bitcast float %4565 to i32, !dbg !1096
  %4580 = and i32 %4579, -2147483648, !dbg !1096
  %4581 = icmp eq i32 %4580, 0, !dbg !1096
  %4582 = icmp ne i32 %4580, 0, !dbg !1096
  %is_pos_inf1098 = and i1 %is_inf1096, %4581, !dbg !1096
  %is_neg_inf1099 = and i1 %is_inf1096, %4582, !dbg !1096
  %is_pos_max1100 = and i1 %is_maxfinite1097, %4581, !dbg !1096
  %is_neg_max1101 = and i1 %is_maxfinite1097, %4582, !dbg !1096
  %overflow_cond1102 = and i1 %4571, %is_inf1096, !dbg !1096
  br i1 %overflow_cond1102, label %4583, label %4585, !dbg !1096

4583:                                             ; preds = %4564
  %4584 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4585, !dbg !1096

4585:                                             ; preds = %4564, %4583
  %4586 = bitcast float %4484 to i32, !dbg !1096
  %4587 = and i32 %4586, 2139095040, !dbg !1096
  %4588 = icmp eq i32 %4587, 0, !dbg !1096
  %4589 = and i32 %4586, 8388607, !dbg !1096
  %4590 = icmp ne i32 %4589, 0, !dbg !1096
  %is_subnormal1103 = and i1 %4588, %4590, !dbg !1096
  %4591 = xor i1 %is_subnormal1103, true, !dbg !1096
  %4592 = and i1 true, %4591, !dbg !1096
  %4593 = bitcast float %4352 to i32, !dbg !1096
  %4594 = and i32 %4593, 2139095040, !dbg !1096
  %4595 = icmp eq i32 %4594, 0, !dbg !1096
  %4596 = and i32 %4593, 8388607, !dbg !1096
  %4597 = icmp ne i32 %4596, 0, !dbg !1096
  %is_subnormal1104 = and i1 %4595, %4597, !dbg !1096
  %4598 = xor i1 %is_subnormal1104, true, !dbg !1096
  %4599 = and i1 %4592, %4598, !dbg !1096
  %4600 = bitcast float %4565 to i32, !dbg !1096
  %4601 = and i32 %4600, 2139095040, !dbg !1096
  %4602 = icmp eq i32 %4601, 0, !dbg !1096
  %4603 = and i32 %4600, 8388607, !dbg !1096
  %4604 = icmp ne i32 %4603, 0, !dbg !1096
  %is_subnormal1105 = and i1 %4602, %4604, !dbg !1096
  %subnormal_cond1106 = and i1 %4599, %is_subnormal1105, !dbg !1096
  br i1 %subnormal_cond1106, label %4605, label %4607, !dbg !1096

4605:                                             ; preds = %4585
  %4606 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4607, !dbg !1096

4607:                                             ; preds = %4585, %4605
  %4608 = bitcast float %4565 to i32, !dbg !1096
  %4609 = bitcast float %4565 to i32, !dbg !1096
  %4610 = and i32 %4609, 2139095040, !dbg !1096
  %4611 = icmp eq i32 %4610, 2139095040, !dbg !1096
  %4612 = and i32 %4609, 8388607, !dbg !1096
  %4613 = icmp ne i32 %4612, 0, !dbg !1096
  %is_nan1107 = and i1 %4611, %4613, !dbg !1096
  %4614 = and i32 %4608, 4194304, !dbg !1096
  %4615 = icmp eq i32 %4614, 0, !dbg !1096
  %is_snan1108 = and i1 %is_nan1107, %4615, !dbg !1096
  %4616 = or i1 false, %is_snan1108, !dbg !1096
  %4617 = or i1 %4616, false, !dbg !1096
  %4618 = bitcast float %4565 to i32, !dbg !1096
  %4619 = and i32 %4618, 2139095040, !dbg !1096
  %4620 = icmp eq i32 %4619, 2139095040, !dbg !1096
  %4621 = and i32 %4618, 8388607, !dbg !1096
  %4622 = icmp eq i32 %4621, 0, !dbg !1096
  %is_inf1109 = and i1 %4620, %4622, !dbg !1096
  %4623 = and i1 false, %is_inf1109, !dbg !1096
  %4624 = bitcast float %4565 to i32, !dbg !1096
  %4625 = and i32 %4624, 2147483647, !dbg !1096
  %is_zero1110 = icmp eq i32 %4625, 0, !dbg !1096
  %4626 = and i1 false, %is_zero1110, !dbg !1096
  %4627 = or i1 %4623, %4626, !dbg !1096
  %4628 = or i1 %4617, %4627, !dbg !1096
  br i1 %4628, label %4629, label %4631, !dbg !1096

4629:                                             ; preds = %4607
  %4630 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4631, !dbg !1096

4631:                                             ; preds = %4607, %4629
  %4632 = call float @llvm.nvvm.fma.rn.f(float 0x3F23F971C0000000, float %4565, float 0x3F55F0BDA0000000) #5, !dbg !1096
  %4633 = bitcast float %4565 to i32, !dbg !1096
  %4634 = and i32 %4633, 2139095040, !dbg !1096
  %is_finite1111 = icmp ne i32 %4634, 2139095040, !dbg !1096
  %4635 = and i1 true, %is_finite1111, !dbg !1096
  %4636 = bitcast float %4632 to i32, !dbg !1096
  %4637 = and i32 %4636, 2139095040, !dbg !1096
  %4638 = icmp eq i32 %4637, 2139095040, !dbg !1096
  %4639 = and i32 %4636, 8388607, !dbg !1096
  %4640 = icmp eq i32 %4639, 0, !dbg !1096
  %is_inf1112 = and i1 %4638, %4640, !dbg !1096
  %4641 = bitcast float %4632 to i32, !dbg !1096
  %4642 = and i32 %4641, 2147483647, !dbg !1096
  %is_maxfinite1113 = icmp eq i32 %4642, 2139095039, !dbg !1096
  %4643 = bitcast float %4632 to i32, !dbg !1096
  %4644 = and i32 %4643, -2147483648, !dbg !1096
  %4645 = icmp eq i32 %4644, 0, !dbg !1096
  %4646 = icmp ne i32 %4644, 0, !dbg !1096
  %is_pos_inf1114 = and i1 %is_inf1112, %4645, !dbg !1096
  %is_neg_inf1115 = and i1 %is_inf1112, %4646, !dbg !1096
  %is_pos_max1116 = and i1 %is_maxfinite1113, %4645, !dbg !1096
  %is_neg_max1117 = and i1 %is_maxfinite1113, %4646, !dbg !1096
  %overflow_cond1118 = and i1 %4635, %is_inf1112, !dbg !1096
  br i1 %overflow_cond1118, label %4647, label %4649, !dbg !1096

4647:                                             ; preds = %4631
  %4648 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4649, !dbg !1096

4649:                                             ; preds = %4631, %4647
  %4650 = bitcast float %4565 to i32, !dbg !1096
  %4651 = and i32 %4650, 2139095040, !dbg !1096
  %4652 = icmp eq i32 %4651, 0, !dbg !1096
  %4653 = and i32 %4650, 8388607, !dbg !1096
  %4654 = icmp ne i32 %4653, 0, !dbg !1096
  %is_subnormal1119 = and i1 %4652, %4654, !dbg !1096
  %4655 = xor i1 %is_subnormal1119, true, !dbg !1096
  %4656 = and i1 true, %4655, !dbg !1096
  %4657 = and i1 %4656, true, !dbg !1096
  %4658 = bitcast float %4632 to i32, !dbg !1096
  %4659 = and i32 %4658, 2139095040, !dbg !1096
  %4660 = icmp eq i32 %4659, 0, !dbg !1096
  %4661 = and i32 %4658, 8388607, !dbg !1096
  %4662 = icmp ne i32 %4661, 0, !dbg !1096
  %is_subnormal1120 = and i1 %4660, %4662, !dbg !1096
  %4663 = bitcast float %4632 to i32, !dbg !1096
  %4664 = and i32 %4663, 2147483647, !dbg !1096
  %is_zero1121 = icmp eq i32 %4664, 0, !dbg !1096
  %4665 = bitcast float %4565 to i32, !dbg !1096
  %4666 = and i32 %4665, 2147483647, !dbg !1096
  %is_zero1122 = icmp eq i32 %4666, 0, !dbg !1096
  %4667 = xor i1 %is_zero1122, true, !dbg !1096
  %4668 = and i1 true, %4667, !dbg !1096
  %4669 = and i1 %4668, true, !dbg !1096
  %4670 = and i1 %is_zero1121, %4669, !dbg !1096
  %is_tiny1123 = or i1 %is_subnormal1120, %4670, !dbg !1096
  %underflow_cond1124 = and i1 %4657, %is_tiny1123, !dbg !1096
  br i1 %underflow_cond1124, label %4671, label %4673, !dbg !1096

4671:                                             ; preds = %4649
  %4672 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4673, !dbg !1096

4673:                                             ; preds = %4649, %4671
  %4674 = bitcast float %4565 to i32, !dbg !1096
  %4675 = and i32 %4674, 2139095040, !dbg !1096
  %4676 = icmp eq i32 %4675, 0, !dbg !1096
  %4677 = and i32 %4674, 8388607, !dbg !1096
  %4678 = icmp ne i32 %4677, 0, !dbg !1096
  %is_subnormal1125 = and i1 %4676, %4678, !dbg !1096
  %4679 = xor i1 %is_subnormal1125, true, !dbg !1096
  %4680 = and i1 true, %4679, !dbg !1096
  %4681 = and i1 %4680, true, !dbg !1096
  %4682 = bitcast float %4632 to i32, !dbg !1096
  %4683 = and i32 %4682, 2139095040, !dbg !1096
  %4684 = icmp eq i32 %4683, 0, !dbg !1096
  %4685 = and i32 %4682, 8388607, !dbg !1096
  %4686 = icmp ne i32 %4685, 0, !dbg !1096
  %is_subnormal1126 = and i1 %4684, %4686, !dbg !1096
  %subnormal_cond1127 = and i1 %4681, %is_subnormal1126, !dbg !1096
  br i1 %subnormal_cond1127, label %4687, label %4689, !dbg !1096

4687:                                             ; preds = %4673
  %4688 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4689, !dbg !1096

4689:                                             ; preds = %4673, %4687
  %4690 = bitcast float %4632 to i32, !dbg !1096
  %4691 = bitcast float %4632 to i32, !dbg !1096
  %4692 = and i32 %4691, 2139095040, !dbg !1096
  %4693 = icmp eq i32 %4692, 2139095040, !dbg !1096
  %4694 = and i32 %4691, 8388607, !dbg !1096
  %4695 = icmp ne i32 %4694, 0, !dbg !1096
  %is_nan1128 = and i1 %4693, %4695, !dbg !1096
  %4696 = and i32 %4690, 4194304, !dbg !1096
  %4697 = icmp eq i32 %4696, 0, !dbg !1096
  %is_snan1129 = and i1 %is_nan1128, %4697, !dbg !1096
  %4698 = bitcast float %4565 to i32, !dbg !1096
  %4699 = bitcast float %4565 to i32, !dbg !1096
  %4700 = and i32 %4699, 2139095040, !dbg !1096
  %4701 = icmp eq i32 %4700, 2139095040, !dbg !1096
  %4702 = and i32 %4699, 8388607, !dbg !1096
  %4703 = icmp ne i32 %4702, 0, !dbg !1096
  %is_nan1130 = and i1 %4701, %4703, !dbg !1096
  %4704 = and i32 %4698, 4194304, !dbg !1096
  %4705 = icmp eq i32 %4704, 0, !dbg !1096
  %is_snan1131 = and i1 %is_nan1130, %4705, !dbg !1096
  %4706 = or i1 %is_snan1129, %is_snan1131, !dbg !1096
  %4707 = or i1 %4706, false, !dbg !1096
  %4708 = bitcast float %4632 to i32, !dbg !1096
  %4709 = and i32 %4708, 2147483647, !dbg !1096
  %is_zero1132 = icmp eq i32 %4709, 0, !dbg !1096
  %4710 = bitcast float %4565 to i32, !dbg !1096
  %4711 = and i32 %4710, 2139095040, !dbg !1096
  %4712 = icmp eq i32 %4711, 2139095040, !dbg !1096
  %4713 = and i32 %4710, 8388607, !dbg !1096
  %4714 = icmp eq i32 %4713, 0, !dbg !1096
  %is_inf1133 = and i1 %4712, %4714, !dbg !1096
  %4715 = and i1 %is_zero1132, %is_inf1133, !dbg !1096
  %4716 = bitcast float %4632 to i32, !dbg !1096
  %4717 = and i32 %4716, 2139095040, !dbg !1096
  %4718 = icmp eq i32 %4717, 2139095040, !dbg !1096
  %4719 = and i32 %4716, 8388607, !dbg !1096
  %4720 = icmp eq i32 %4719, 0, !dbg !1096
  %is_inf1134 = and i1 %4718, %4720, !dbg !1096
  %4721 = bitcast float %4565 to i32, !dbg !1096
  %4722 = and i32 %4721, 2147483647, !dbg !1096
  %is_zero1135 = icmp eq i32 %4722, 0, !dbg !1096
  %4723 = and i1 %is_inf1134, %is_zero1135, !dbg !1096
  %4724 = or i1 %4715, %4723, !dbg !1096
  %4725 = or i1 %4707, %4724, !dbg !1096
  br i1 %4725, label %4726, label %4728, !dbg !1096

4726:                                             ; preds = %4689
  %4727 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4728, !dbg !1096

4728:                                             ; preds = %4689, %4726
  %4729 = call float @llvm.nvvm.fma.rn.f(float %4632, float %4565, float 0x3F83B30AC0000000) #5, !dbg !1096
  %4730 = bitcast float %4632 to i32, !dbg !1096
  %4731 = and i32 %4730, 2139095040, !dbg !1096
  %is_finite1136 = icmp ne i32 %4731, 2139095040, !dbg !1096
  %4732 = and i1 true, %is_finite1136, !dbg !1096
  %4733 = bitcast float %4565 to i32, !dbg !1096
  %4734 = and i32 %4733, 2139095040, !dbg !1096
  %is_finite1137 = icmp ne i32 %4734, 2139095040, !dbg !1096
  %4735 = and i1 %4732, %is_finite1137, !dbg !1096
  %4736 = bitcast float %4729 to i32, !dbg !1096
  %4737 = and i32 %4736, 2139095040, !dbg !1096
  %4738 = icmp eq i32 %4737, 2139095040, !dbg !1096
  %4739 = and i32 %4736, 8388607, !dbg !1096
  %4740 = icmp eq i32 %4739, 0, !dbg !1096
  %is_inf1138 = and i1 %4738, %4740, !dbg !1096
  %4741 = bitcast float %4729 to i32, !dbg !1096
  %4742 = and i32 %4741, 2147483647, !dbg !1096
  %is_maxfinite1139 = icmp eq i32 %4742, 2139095039, !dbg !1096
  %4743 = bitcast float %4729 to i32, !dbg !1096
  %4744 = and i32 %4743, -2147483648, !dbg !1096
  %4745 = icmp eq i32 %4744, 0, !dbg !1096
  %4746 = icmp ne i32 %4744, 0, !dbg !1096
  %is_pos_inf1140 = and i1 %is_inf1138, %4745, !dbg !1096
  %is_neg_inf1141 = and i1 %is_inf1138, %4746, !dbg !1096
  %is_pos_max1142 = and i1 %is_maxfinite1139, %4745, !dbg !1096
  %is_neg_max1143 = and i1 %is_maxfinite1139, %4746, !dbg !1096
  %overflow_cond1144 = and i1 %4735, %is_inf1138, !dbg !1096
  br i1 %overflow_cond1144, label %4747, label %4749, !dbg !1096

4747:                                             ; preds = %4728
  %4748 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4749, !dbg !1096

4749:                                             ; preds = %4728, %4747
  %4750 = bitcast float %4632 to i32, !dbg !1096
  %4751 = and i32 %4750, 2139095040, !dbg !1096
  %4752 = icmp eq i32 %4751, 0, !dbg !1096
  %4753 = and i32 %4750, 8388607, !dbg !1096
  %4754 = icmp ne i32 %4753, 0, !dbg !1096
  %is_subnormal1145 = and i1 %4752, %4754, !dbg !1096
  %4755 = xor i1 %is_subnormal1145, true, !dbg !1096
  %4756 = and i1 true, %4755, !dbg !1096
  %4757 = bitcast float %4565 to i32, !dbg !1096
  %4758 = and i32 %4757, 2139095040, !dbg !1096
  %4759 = icmp eq i32 %4758, 0, !dbg !1096
  %4760 = and i32 %4757, 8388607, !dbg !1096
  %4761 = icmp ne i32 %4760, 0, !dbg !1096
  %is_subnormal1146 = and i1 %4759, %4761, !dbg !1096
  %4762 = xor i1 %is_subnormal1146, true, !dbg !1096
  %4763 = and i1 %4756, %4762, !dbg !1096
  %4764 = and i1 %4763, true, !dbg !1096
  %4765 = bitcast float %4729 to i32, !dbg !1096
  %4766 = and i32 %4765, 2139095040, !dbg !1096
  %4767 = icmp eq i32 %4766, 0, !dbg !1096
  %4768 = and i32 %4765, 8388607, !dbg !1096
  %4769 = icmp ne i32 %4768, 0, !dbg !1096
  %is_subnormal1147 = and i1 %4767, %4769, !dbg !1096
  %4770 = bitcast float %4729 to i32, !dbg !1096
  %4771 = and i32 %4770, 2147483647, !dbg !1096
  %is_zero1148 = icmp eq i32 %4771, 0, !dbg !1096
  %4772 = bitcast float %4632 to i32, !dbg !1096
  %4773 = and i32 %4772, 2147483647, !dbg !1096
  %is_zero1149 = icmp eq i32 %4773, 0, !dbg !1096
  %4774 = xor i1 %is_zero1149, true, !dbg !1096
  %4775 = bitcast float %4565 to i32, !dbg !1096
  %4776 = and i32 %4775, 2147483647, !dbg !1096
  %is_zero1150 = icmp eq i32 %4776, 0, !dbg !1096
  %4777 = xor i1 %is_zero1150, true, !dbg !1096
  %4778 = and i1 %4774, %4777, !dbg !1096
  %4779 = and i1 %4778, true, !dbg !1096
  %4780 = and i1 %is_zero1148, %4779, !dbg !1096
  %is_tiny1151 = or i1 %is_subnormal1147, %4780, !dbg !1096
  %underflow_cond1152 = and i1 %4764, %is_tiny1151, !dbg !1096
  br i1 %underflow_cond1152, label %4781, label %4783, !dbg !1096

4781:                                             ; preds = %4749
  %4782 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4783, !dbg !1096

4783:                                             ; preds = %4749, %4781
  %4784 = bitcast float %4632 to i32, !dbg !1096
  %4785 = and i32 %4784, 2139095040, !dbg !1096
  %4786 = icmp eq i32 %4785, 0, !dbg !1096
  %4787 = and i32 %4784, 8388607, !dbg !1096
  %4788 = icmp ne i32 %4787, 0, !dbg !1096
  %is_subnormal1153 = and i1 %4786, %4788, !dbg !1096
  %4789 = xor i1 %is_subnormal1153, true, !dbg !1096
  %4790 = and i1 true, %4789, !dbg !1096
  %4791 = bitcast float %4565 to i32, !dbg !1096
  %4792 = and i32 %4791, 2139095040, !dbg !1096
  %4793 = icmp eq i32 %4792, 0, !dbg !1096
  %4794 = and i32 %4791, 8388607, !dbg !1096
  %4795 = icmp ne i32 %4794, 0, !dbg !1096
  %is_subnormal1154 = and i1 %4793, %4795, !dbg !1096
  %4796 = xor i1 %is_subnormal1154, true, !dbg !1096
  %4797 = and i1 %4790, %4796, !dbg !1096
  %4798 = and i1 %4797, true, !dbg !1096
  %4799 = bitcast float %4729 to i32, !dbg !1096
  %4800 = and i32 %4799, 2139095040, !dbg !1096
  %4801 = icmp eq i32 %4800, 0, !dbg !1096
  %4802 = and i32 %4799, 8388607, !dbg !1096
  %4803 = icmp ne i32 %4802, 0, !dbg !1096
  %is_subnormal1155 = and i1 %4801, %4803, !dbg !1096
  %subnormal_cond1156 = and i1 %4798, %is_subnormal1155, !dbg !1096
  br i1 %subnormal_cond1156, label %4804, label %4806, !dbg !1096

4804:                                             ; preds = %4783
  %4805 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4806, !dbg !1096

4806:                                             ; preds = %4783, %4804
  %4807 = bitcast float %4729 to i32, !dbg !1096
  %4808 = bitcast float %4729 to i32, !dbg !1096
  %4809 = and i32 %4808, 2139095040, !dbg !1096
  %4810 = icmp eq i32 %4809, 2139095040, !dbg !1096
  %4811 = and i32 %4808, 8388607, !dbg !1096
  %4812 = icmp ne i32 %4811, 0, !dbg !1096
  %is_nan1157 = and i1 %4810, %4812, !dbg !1096
  %4813 = and i32 %4807, 4194304, !dbg !1096
  %4814 = icmp eq i32 %4813, 0, !dbg !1096
  %is_snan1158 = and i1 %is_nan1157, %4814, !dbg !1096
  %4815 = bitcast float %4565 to i32, !dbg !1096
  %4816 = bitcast float %4565 to i32, !dbg !1096
  %4817 = and i32 %4816, 2139095040, !dbg !1096
  %4818 = icmp eq i32 %4817, 2139095040, !dbg !1096
  %4819 = and i32 %4816, 8388607, !dbg !1096
  %4820 = icmp ne i32 %4819, 0, !dbg !1096
  %is_nan1159 = and i1 %4818, %4820, !dbg !1096
  %4821 = and i32 %4815, 4194304, !dbg !1096
  %4822 = icmp eq i32 %4821, 0, !dbg !1096
  %is_snan1160 = and i1 %is_nan1159, %4822, !dbg !1096
  %4823 = or i1 %is_snan1158, %is_snan1160, !dbg !1096
  %4824 = or i1 %4823, false, !dbg !1096
  %4825 = bitcast float %4729 to i32, !dbg !1096
  %4826 = and i32 %4825, 2147483647, !dbg !1096
  %is_zero1161 = icmp eq i32 %4826, 0, !dbg !1096
  %4827 = bitcast float %4565 to i32, !dbg !1096
  %4828 = and i32 %4827, 2139095040, !dbg !1096
  %4829 = icmp eq i32 %4828, 2139095040, !dbg !1096
  %4830 = and i32 %4827, 8388607, !dbg !1096
  %4831 = icmp eq i32 %4830, 0, !dbg !1096
  %is_inf1162 = and i1 %4829, %4831, !dbg !1096
  %4832 = and i1 %is_zero1161, %is_inf1162, !dbg !1096
  %4833 = bitcast float %4729 to i32, !dbg !1096
  %4834 = and i32 %4833, 2139095040, !dbg !1096
  %4835 = icmp eq i32 %4834, 2139095040, !dbg !1096
  %4836 = and i32 %4833, 8388607, !dbg !1096
  %4837 = icmp eq i32 %4836, 0, !dbg !1096
  %is_inf1163 = and i1 %4835, %4837, !dbg !1096
  %4838 = bitcast float %4565 to i32, !dbg !1096
  %4839 = and i32 %4838, 2147483647, !dbg !1096
  %is_zero1164 = icmp eq i32 %4839, 0, !dbg !1096
  %4840 = and i1 %is_inf1163, %is_zero1164, !dbg !1096
  %4841 = or i1 %4832, %4840, !dbg !1096
  %4842 = or i1 %4824, %4841, !dbg !1096
  br i1 %4842, label %4843, label %4845, !dbg !1096

4843:                                             ; preds = %4806
  %4844 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4845, !dbg !1096

4845:                                             ; preds = %4806, %4843
  %4846 = call float @llvm.nvvm.fma.rn.f(float %4729, float %4565, float 0x3FAC6AF760000000) #5, !dbg !1096
  %4847 = bitcast float %4729 to i32, !dbg !1096
  %4848 = and i32 %4847, 2139095040, !dbg !1096
  %is_finite1165 = icmp ne i32 %4848, 2139095040, !dbg !1096
  %4849 = and i1 true, %is_finite1165, !dbg !1096
  %4850 = bitcast float %4565 to i32, !dbg !1096
  %4851 = and i32 %4850, 2139095040, !dbg !1096
  %is_finite1166 = icmp ne i32 %4851, 2139095040, !dbg !1096
  %4852 = and i1 %4849, %is_finite1166, !dbg !1096
  %4853 = bitcast float %4846 to i32, !dbg !1096
  %4854 = and i32 %4853, 2139095040, !dbg !1096
  %4855 = icmp eq i32 %4854, 2139095040, !dbg !1096
  %4856 = and i32 %4853, 8388607, !dbg !1096
  %4857 = icmp eq i32 %4856, 0, !dbg !1096
  %is_inf1167 = and i1 %4855, %4857, !dbg !1096
  %4858 = bitcast float %4846 to i32, !dbg !1096
  %4859 = and i32 %4858, 2147483647, !dbg !1096
  %is_maxfinite1168 = icmp eq i32 %4859, 2139095039, !dbg !1096
  %4860 = bitcast float %4846 to i32, !dbg !1096
  %4861 = and i32 %4860, -2147483648, !dbg !1096
  %4862 = icmp eq i32 %4861, 0, !dbg !1096
  %4863 = icmp ne i32 %4861, 0, !dbg !1096
  %is_pos_inf1169 = and i1 %is_inf1167, %4862, !dbg !1096
  %is_neg_inf1170 = and i1 %is_inf1167, %4863, !dbg !1096
  %is_pos_max1171 = and i1 %is_maxfinite1168, %4862, !dbg !1096
  %is_neg_max1172 = and i1 %is_maxfinite1168, %4863, !dbg !1096
  %overflow_cond1173 = and i1 %4852, %is_inf1167, !dbg !1096
  br i1 %overflow_cond1173, label %4864, label %4866, !dbg !1096

4864:                                             ; preds = %4845
  %4865 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4866, !dbg !1096

4866:                                             ; preds = %4845, %4864
  %4867 = bitcast float %4729 to i32, !dbg !1096
  %4868 = and i32 %4867, 2139095040, !dbg !1096
  %4869 = icmp eq i32 %4868, 0, !dbg !1096
  %4870 = and i32 %4867, 8388607, !dbg !1096
  %4871 = icmp ne i32 %4870, 0, !dbg !1096
  %is_subnormal1174 = and i1 %4869, %4871, !dbg !1096
  %4872 = xor i1 %is_subnormal1174, true, !dbg !1096
  %4873 = and i1 true, %4872, !dbg !1096
  %4874 = bitcast float %4565 to i32, !dbg !1096
  %4875 = and i32 %4874, 2139095040, !dbg !1096
  %4876 = icmp eq i32 %4875, 0, !dbg !1096
  %4877 = and i32 %4874, 8388607, !dbg !1096
  %4878 = icmp ne i32 %4877, 0, !dbg !1096
  %is_subnormal1175 = and i1 %4876, %4878, !dbg !1096
  %4879 = xor i1 %is_subnormal1175, true, !dbg !1096
  %4880 = and i1 %4873, %4879, !dbg !1096
  %4881 = and i1 %4880, true, !dbg !1096
  %4882 = bitcast float %4846 to i32, !dbg !1096
  %4883 = and i32 %4882, 2139095040, !dbg !1096
  %4884 = icmp eq i32 %4883, 0, !dbg !1096
  %4885 = and i32 %4882, 8388607, !dbg !1096
  %4886 = icmp ne i32 %4885, 0, !dbg !1096
  %is_subnormal1176 = and i1 %4884, %4886, !dbg !1096
  %4887 = bitcast float %4846 to i32, !dbg !1096
  %4888 = and i32 %4887, 2147483647, !dbg !1096
  %is_zero1177 = icmp eq i32 %4888, 0, !dbg !1096
  %4889 = bitcast float %4729 to i32, !dbg !1096
  %4890 = and i32 %4889, 2147483647, !dbg !1096
  %is_zero1178 = icmp eq i32 %4890, 0, !dbg !1096
  %4891 = xor i1 %is_zero1178, true, !dbg !1096
  %4892 = bitcast float %4565 to i32, !dbg !1096
  %4893 = and i32 %4892, 2147483647, !dbg !1096
  %is_zero1179 = icmp eq i32 %4893, 0, !dbg !1096
  %4894 = xor i1 %is_zero1179, true, !dbg !1096
  %4895 = and i1 %4891, %4894, !dbg !1096
  %4896 = and i1 %4895, true, !dbg !1096
  %4897 = and i1 %is_zero1177, %4896, !dbg !1096
  %is_tiny1180 = or i1 %is_subnormal1176, %4897, !dbg !1096
  %underflow_cond1181 = and i1 %4881, %is_tiny1180, !dbg !1096
  br i1 %underflow_cond1181, label %4898, label %4900, !dbg !1096

4898:                                             ; preds = %4866
  %4899 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %4900, !dbg !1096

4900:                                             ; preds = %4866, %4898
  %4901 = bitcast float %4729 to i32, !dbg !1096
  %4902 = and i32 %4901, 2139095040, !dbg !1096
  %4903 = icmp eq i32 %4902, 0, !dbg !1096
  %4904 = and i32 %4901, 8388607, !dbg !1096
  %4905 = icmp ne i32 %4904, 0, !dbg !1096
  %is_subnormal1182 = and i1 %4903, %4905, !dbg !1096
  %4906 = xor i1 %is_subnormal1182, true, !dbg !1096
  %4907 = and i1 true, %4906, !dbg !1096
  %4908 = bitcast float %4565 to i32, !dbg !1096
  %4909 = and i32 %4908, 2139095040, !dbg !1096
  %4910 = icmp eq i32 %4909, 0, !dbg !1096
  %4911 = and i32 %4908, 8388607, !dbg !1096
  %4912 = icmp ne i32 %4911, 0, !dbg !1096
  %is_subnormal1183 = and i1 %4910, %4912, !dbg !1096
  %4913 = xor i1 %is_subnormal1183, true, !dbg !1096
  %4914 = and i1 %4907, %4913, !dbg !1096
  %4915 = and i1 %4914, true, !dbg !1096
  %4916 = bitcast float %4846 to i32, !dbg !1096
  %4917 = and i32 %4916, 2139095040, !dbg !1096
  %4918 = icmp eq i32 %4917, 0, !dbg !1096
  %4919 = and i32 %4916, 8388607, !dbg !1096
  %4920 = icmp ne i32 %4919, 0, !dbg !1096
  %is_subnormal1184 = and i1 %4918, %4920, !dbg !1096
  %subnormal_cond1185 = and i1 %4915, %is_subnormal1184, !dbg !1096
  br i1 %subnormal_cond1185, label %4921, label %4923, !dbg !1096

4921:                                             ; preds = %4900
  %4922 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %4923, !dbg !1096

4923:                                             ; preds = %4900, %4921
  %4924 = bitcast float %4846 to i32, !dbg !1096
  %4925 = bitcast float %4846 to i32, !dbg !1096
  %4926 = and i32 %4925, 2139095040, !dbg !1096
  %4927 = icmp eq i32 %4926, 2139095040, !dbg !1096
  %4928 = and i32 %4925, 8388607, !dbg !1096
  %4929 = icmp ne i32 %4928, 0, !dbg !1096
  %is_nan1186 = and i1 %4927, %4929, !dbg !1096
  %4930 = and i32 %4924, 4194304, !dbg !1096
  %4931 = icmp eq i32 %4930, 0, !dbg !1096
  %is_snan1187 = and i1 %is_nan1186, %4931, !dbg !1096
  %4932 = bitcast float %4565 to i32, !dbg !1096
  %4933 = bitcast float %4565 to i32, !dbg !1096
  %4934 = and i32 %4933, 2139095040, !dbg !1096
  %4935 = icmp eq i32 %4934, 2139095040, !dbg !1096
  %4936 = and i32 %4933, 8388607, !dbg !1096
  %4937 = icmp ne i32 %4936, 0, !dbg !1096
  %is_nan1188 = and i1 %4935, %4937, !dbg !1096
  %4938 = and i32 %4932, 4194304, !dbg !1096
  %4939 = icmp eq i32 %4938, 0, !dbg !1096
  %is_snan1189 = and i1 %is_nan1188, %4939, !dbg !1096
  %4940 = or i1 %is_snan1187, %is_snan1189, !dbg !1096
  %4941 = or i1 %4940, false, !dbg !1096
  %4942 = bitcast float %4846 to i32, !dbg !1096
  %4943 = and i32 %4942, 2147483647, !dbg !1096
  %is_zero1190 = icmp eq i32 %4943, 0, !dbg !1096
  %4944 = bitcast float %4565 to i32, !dbg !1096
  %4945 = and i32 %4944, 2139095040, !dbg !1096
  %4946 = icmp eq i32 %4945, 2139095040, !dbg !1096
  %4947 = and i32 %4944, 8388607, !dbg !1096
  %4948 = icmp eq i32 %4947, 0, !dbg !1096
  %is_inf1191 = and i1 %4946, %4948, !dbg !1096
  %4949 = and i1 %is_zero1190, %is_inf1191, !dbg !1096
  %4950 = bitcast float %4846 to i32, !dbg !1096
  %4951 = and i32 %4950, 2139095040, !dbg !1096
  %4952 = icmp eq i32 %4951, 2139095040, !dbg !1096
  %4953 = and i32 %4950, 8388607, !dbg !1096
  %4954 = icmp eq i32 %4953, 0, !dbg !1096
  %is_inf1192 = and i1 %4952, %4954, !dbg !1096
  %4955 = bitcast float %4565 to i32, !dbg !1096
  %4956 = and i32 %4955, 2147483647, !dbg !1096
  %is_zero1193 = icmp eq i32 %4956, 0, !dbg !1096
  %4957 = and i1 %is_inf1192, %is_zero1193, !dbg !1096
  %4958 = or i1 %4949, %4957, !dbg !1096
  %4959 = or i1 %4941, %4958, !dbg !1096
  br i1 %4959, label %4960, label %4962, !dbg !1096

4960:                                             ; preds = %4923
  %4961 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %4962, !dbg !1096

4962:                                             ; preds = %4923, %4960
  %4963 = call float @llvm.nvvm.fma.rn.f(float %4846, float %4565, float 0x3FCEBFBD80000000) #5, !dbg !1096
  %4964 = bitcast float %4846 to i32, !dbg !1096
  %4965 = and i32 %4964, 2139095040, !dbg !1096
  %is_finite1194 = icmp ne i32 %4965, 2139095040, !dbg !1096
  %4966 = and i1 true, %is_finite1194, !dbg !1096
  %4967 = bitcast float %4565 to i32, !dbg !1096
  %4968 = and i32 %4967, 2139095040, !dbg !1096
  %is_finite1195 = icmp ne i32 %4968, 2139095040, !dbg !1096
  %4969 = and i1 %4966, %is_finite1195, !dbg !1096
  %4970 = bitcast float %4963 to i32, !dbg !1096
  %4971 = and i32 %4970, 2139095040, !dbg !1096
  %4972 = icmp eq i32 %4971, 2139095040, !dbg !1096
  %4973 = and i32 %4970, 8388607, !dbg !1096
  %4974 = icmp eq i32 %4973, 0, !dbg !1096
  %is_inf1196 = and i1 %4972, %4974, !dbg !1096
  %4975 = bitcast float %4963 to i32, !dbg !1096
  %4976 = and i32 %4975, 2147483647, !dbg !1096
  %is_maxfinite1197 = icmp eq i32 %4976, 2139095039, !dbg !1096
  %4977 = bitcast float %4963 to i32, !dbg !1096
  %4978 = and i32 %4977, -2147483648, !dbg !1096
  %4979 = icmp eq i32 %4978, 0, !dbg !1096
  %4980 = icmp ne i32 %4978, 0, !dbg !1096
  %is_pos_inf1198 = and i1 %is_inf1196, %4979, !dbg !1096
  %is_neg_inf1199 = and i1 %is_inf1196, %4980, !dbg !1096
  %is_pos_max1200 = and i1 %is_maxfinite1197, %4979, !dbg !1096
  %is_neg_max1201 = and i1 %is_maxfinite1197, %4980, !dbg !1096
  %overflow_cond1202 = and i1 %4969, %is_inf1196, !dbg !1096
  br i1 %overflow_cond1202, label %4981, label %4983, !dbg !1096

4981:                                             ; preds = %4962
  %4982 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %4983, !dbg !1096

4983:                                             ; preds = %4962, %4981
  %4984 = bitcast float %4846 to i32, !dbg !1096
  %4985 = and i32 %4984, 2139095040, !dbg !1096
  %4986 = icmp eq i32 %4985, 0, !dbg !1096
  %4987 = and i32 %4984, 8388607, !dbg !1096
  %4988 = icmp ne i32 %4987, 0, !dbg !1096
  %is_subnormal1203 = and i1 %4986, %4988, !dbg !1096
  %4989 = xor i1 %is_subnormal1203, true, !dbg !1096
  %4990 = and i1 true, %4989, !dbg !1096
  %4991 = bitcast float %4565 to i32, !dbg !1096
  %4992 = and i32 %4991, 2139095040, !dbg !1096
  %4993 = icmp eq i32 %4992, 0, !dbg !1096
  %4994 = and i32 %4991, 8388607, !dbg !1096
  %4995 = icmp ne i32 %4994, 0, !dbg !1096
  %is_subnormal1204 = and i1 %4993, %4995, !dbg !1096
  %4996 = xor i1 %is_subnormal1204, true, !dbg !1096
  %4997 = and i1 %4990, %4996, !dbg !1096
  %4998 = and i1 %4997, true, !dbg !1096
  %4999 = bitcast float %4963 to i32, !dbg !1096
  %5000 = and i32 %4999, 2139095040, !dbg !1096
  %5001 = icmp eq i32 %5000, 0, !dbg !1096
  %5002 = and i32 %4999, 8388607, !dbg !1096
  %5003 = icmp ne i32 %5002, 0, !dbg !1096
  %is_subnormal1205 = and i1 %5001, %5003, !dbg !1096
  %5004 = bitcast float %4963 to i32, !dbg !1096
  %5005 = and i32 %5004, 2147483647, !dbg !1096
  %is_zero1206 = icmp eq i32 %5005, 0, !dbg !1096
  %5006 = bitcast float %4846 to i32, !dbg !1096
  %5007 = and i32 %5006, 2147483647, !dbg !1096
  %is_zero1207 = icmp eq i32 %5007, 0, !dbg !1096
  %5008 = xor i1 %is_zero1207, true, !dbg !1096
  %5009 = bitcast float %4565 to i32, !dbg !1096
  %5010 = and i32 %5009, 2147483647, !dbg !1096
  %is_zero1208 = icmp eq i32 %5010, 0, !dbg !1096
  %5011 = xor i1 %is_zero1208, true, !dbg !1096
  %5012 = and i1 %5008, %5011, !dbg !1096
  %5013 = and i1 %5012, true, !dbg !1096
  %5014 = and i1 %is_zero1206, %5013, !dbg !1096
  %is_tiny1209 = or i1 %is_subnormal1205, %5014, !dbg !1096
  %underflow_cond1210 = and i1 %4998, %is_tiny1209, !dbg !1096
  br i1 %underflow_cond1210, label %5015, label %5017, !dbg !1096

5015:                                             ; preds = %4983
  %5016 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %5017, !dbg !1096

5017:                                             ; preds = %4983, %5015
  %5018 = bitcast float %4846 to i32, !dbg !1096
  %5019 = and i32 %5018, 2139095040, !dbg !1096
  %5020 = icmp eq i32 %5019, 0, !dbg !1096
  %5021 = and i32 %5018, 8388607, !dbg !1096
  %5022 = icmp ne i32 %5021, 0, !dbg !1096
  %is_subnormal1211 = and i1 %5020, %5022, !dbg !1096
  %5023 = xor i1 %is_subnormal1211, true, !dbg !1096
  %5024 = and i1 true, %5023, !dbg !1096
  %5025 = bitcast float %4565 to i32, !dbg !1096
  %5026 = and i32 %5025, 2139095040, !dbg !1096
  %5027 = icmp eq i32 %5026, 0, !dbg !1096
  %5028 = and i32 %5025, 8388607, !dbg !1096
  %5029 = icmp ne i32 %5028, 0, !dbg !1096
  %is_subnormal1212 = and i1 %5027, %5029, !dbg !1096
  %5030 = xor i1 %is_subnormal1212, true, !dbg !1096
  %5031 = and i1 %5024, %5030, !dbg !1096
  %5032 = and i1 %5031, true, !dbg !1096
  %5033 = bitcast float %4963 to i32, !dbg !1096
  %5034 = and i32 %5033, 2139095040, !dbg !1096
  %5035 = icmp eq i32 %5034, 0, !dbg !1096
  %5036 = and i32 %5033, 8388607, !dbg !1096
  %5037 = icmp ne i32 %5036, 0, !dbg !1096
  %is_subnormal1213 = and i1 %5035, %5037, !dbg !1096
  %subnormal_cond1214 = and i1 %5032, %is_subnormal1213, !dbg !1096
  br i1 %subnormal_cond1214, label %5038, label %5040, !dbg !1096

5038:                                             ; preds = %5017
  %5039 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5040, !dbg !1096

5040:                                             ; preds = %5017, %5038
  %5041 = bitcast float %4963 to i32, !dbg !1096
  %5042 = bitcast float %4963 to i32, !dbg !1096
  %5043 = and i32 %5042, 2139095040, !dbg !1096
  %5044 = icmp eq i32 %5043, 2139095040, !dbg !1096
  %5045 = and i32 %5042, 8388607, !dbg !1096
  %5046 = icmp ne i32 %5045, 0, !dbg !1096
  %is_nan1215 = and i1 %5044, %5046, !dbg !1096
  %5047 = and i32 %5041, 4194304, !dbg !1096
  %5048 = icmp eq i32 %5047, 0, !dbg !1096
  %is_snan1216 = and i1 %is_nan1215, %5048, !dbg !1096
  %5049 = bitcast float %4565 to i32, !dbg !1096
  %5050 = bitcast float %4565 to i32, !dbg !1096
  %5051 = and i32 %5050, 2139095040, !dbg !1096
  %5052 = icmp eq i32 %5051, 2139095040, !dbg !1096
  %5053 = and i32 %5050, 8388607, !dbg !1096
  %5054 = icmp ne i32 %5053, 0, !dbg !1096
  %is_nan1217 = and i1 %5052, %5054, !dbg !1096
  %5055 = and i32 %5049, 4194304, !dbg !1096
  %5056 = icmp eq i32 %5055, 0, !dbg !1096
  %is_snan1218 = and i1 %is_nan1217, %5056, !dbg !1096
  %5057 = or i1 %is_snan1216, %is_snan1218, !dbg !1096
  %5058 = or i1 %5057, false, !dbg !1096
  %5059 = bitcast float %4963 to i32, !dbg !1096
  %5060 = and i32 %5059, 2147483647, !dbg !1096
  %is_zero1219 = icmp eq i32 %5060, 0, !dbg !1096
  %5061 = bitcast float %4565 to i32, !dbg !1096
  %5062 = and i32 %5061, 2139095040, !dbg !1096
  %5063 = icmp eq i32 %5062, 2139095040, !dbg !1096
  %5064 = and i32 %5061, 8388607, !dbg !1096
  %5065 = icmp eq i32 %5064, 0, !dbg !1096
  %is_inf1220 = and i1 %5063, %5065, !dbg !1096
  %5066 = and i1 %is_zero1219, %is_inf1220, !dbg !1096
  %5067 = bitcast float %4963 to i32, !dbg !1096
  %5068 = and i32 %5067, 2139095040, !dbg !1096
  %5069 = icmp eq i32 %5068, 2139095040, !dbg !1096
  %5070 = and i32 %5067, 8388607, !dbg !1096
  %5071 = icmp eq i32 %5070, 0, !dbg !1096
  %is_inf1221 = and i1 %5069, %5071, !dbg !1096
  %5072 = bitcast float %4565 to i32, !dbg !1096
  %5073 = and i32 %5072, 2147483647, !dbg !1096
  %is_zero1222 = icmp eq i32 %5073, 0, !dbg !1096
  %5074 = and i1 %is_inf1221, %is_zero1222, !dbg !1096
  %5075 = or i1 %5066, %5074, !dbg !1096
  %5076 = or i1 %5058, %5075, !dbg !1096
  br i1 %5076, label %5077, label %5079, !dbg !1096

5077:                                             ; preds = %5040
  %5078 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5079, !dbg !1096

5079:                                             ; preds = %5040, %5077
  %5080 = call float @llvm.nvvm.fma.rn.f(float %4963, float %4565, float 0x3FE62E4300000000) #5, !dbg !1096
  %5081 = bitcast float %4963 to i32, !dbg !1096
  %5082 = and i32 %5081, 2139095040, !dbg !1096
  %is_finite1223 = icmp ne i32 %5082, 2139095040, !dbg !1096
  %5083 = and i1 true, %is_finite1223, !dbg !1096
  %5084 = bitcast float %4565 to i32, !dbg !1096
  %5085 = and i32 %5084, 2139095040, !dbg !1096
  %is_finite1224 = icmp ne i32 %5085, 2139095040, !dbg !1096
  %5086 = and i1 %5083, %is_finite1224, !dbg !1096
  %5087 = bitcast float %5080 to i32, !dbg !1096
  %5088 = and i32 %5087, 2139095040, !dbg !1096
  %5089 = icmp eq i32 %5088, 2139095040, !dbg !1096
  %5090 = and i32 %5087, 8388607, !dbg !1096
  %5091 = icmp eq i32 %5090, 0, !dbg !1096
  %is_inf1225 = and i1 %5089, %5091, !dbg !1096
  %5092 = bitcast float %5080 to i32, !dbg !1096
  %5093 = and i32 %5092, 2147483647, !dbg !1096
  %is_maxfinite1226 = icmp eq i32 %5093, 2139095039, !dbg !1096
  %5094 = bitcast float %5080 to i32, !dbg !1096
  %5095 = and i32 %5094, -2147483648, !dbg !1096
  %5096 = icmp eq i32 %5095, 0, !dbg !1096
  %5097 = icmp ne i32 %5095, 0, !dbg !1096
  %is_pos_inf1227 = and i1 %is_inf1225, %5096, !dbg !1096
  %is_neg_inf1228 = and i1 %is_inf1225, %5097, !dbg !1096
  %is_pos_max1229 = and i1 %is_maxfinite1226, %5096, !dbg !1096
  %is_neg_max1230 = and i1 %is_maxfinite1226, %5097, !dbg !1096
  %overflow_cond1231 = and i1 %5086, %is_inf1225, !dbg !1096
  br i1 %overflow_cond1231, label %5098, label %5100, !dbg !1096

5098:                                             ; preds = %5079
  %5099 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5100, !dbg !1096

5100:                                             ; preds = %5079, %5098
  %5101 = bitcast float %4963 to i32, !dbg !1096
  %5102 = and i32 %5101, 2139095040, !dbg !1096
  %5103 = icmp eq i32 %5102, 0, !dbg !1096
  %5104 = and i32 %5101, 8388607, !dbg !1096
  %5105 = icmp ne i32 %5104, 0, !dbg !1096
  %is_subnormal1232 = and i1 %5103, %5105, !dbg !1096
  %5106 = xor i1 %is_subnormal1232, true, !dbg !1096
  %5107 = and i1 true, %5106, !dbg !1096
  %5108 = bitcast float %4565 to i32, !dbg !1096
  %5109 = and i32 %5108, 2139095040, !dbg !1096
  %5110 = icmp eq i32 %5109, 0, !dbg !1096
  %5111 = and i32 %5108, 8388607, !dbg !1096
  %5112 = icmp ne i32 %5111, 0, !dbg !1096
  %is_subnormal1233 = and i1 %5110, %5112, !dbg !1096
  %5113 = xor i1 %is_subnormal1233, true, !dbg !1096
  %5114 = and i1 %5107, %5113, !dbg !1096
  %5115 = and i1 %5114, true, !dbg !1096
  %5116 = bitcast float %5080 to i32, !dbg !1096
  %5117 = and i32 %5116, 2139095040, !dbg !1096
  %5118 = icmp eq i32 %5117, 0, !dbg !1096
  %5119 = and i32 %5116, 8388607, !dbg !1096
  %5120 = icmp ne i32 %5119, 0, !dbg !1096
  %is_subnormal1234 = and i1 %5118, %5120, !dbg !1096
  %5121 = bitcast float %5080 to i32, !dbg !1096
  %5122 = and i32 %5121, 2147483647, !dbg !1096
  %is_zero1235 = icmp eq i32 %5122, 0, !dbg !1096
  %5123 = bitcast float %4963 to i32, !dbg !1096
  %5124 = and i32 %5123, 2147483647, !dbg !1096
  %is_zero1236 = icmp eq i32 %5124, 0, !dbg !1096
  %5125 = xor i1 %is_zero1236, true, !dbg !1096
  %5126 = bitcast float %4565 to i32, !dbg !1096
  %5127 = and i32 %5126, 2147483647, !dbg !1096
  %is_zero1237 = icmp eq i32 %5127, 0, !dbg !1096
  %5128 = xor i1 %is_zero1237, true, !dbg !1096
  %5129 = and i1 %5125, %5128, !dbg !1096
  %5130 = and i1 %5129, true, !dbg !1096
  %5131 = and i1 %is_zero1235, %5130, !dbg !1096
  %is_tiny1238 = or i1 %is_subnormal1234, %5131, !dbg !1096
  %underflow_cond1239 = and i1 %5115, %is_tiny1238, !dbg !1096
  br i1 %underflow_cond1239, label %5132, label %5134, !dbg !1096

5132:                                             ; preds = %5100
  %5133 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %5134, !dbg !1096

5134:                                             ; preds = %5100, %5132
  %5135 = bitcast float %4963 to i32, !dbg !1096
  %5136 = and i32 %5135, 2139095040, !dbg !1096
  %5137 = icmp eq i32 %5136, 0, !dbg !1096
  %5138 = and i32 %5135, 8388607, !dbg !1096
  %5139 = icmp ne i32 %5138, 0, !dbg !1096
  %is_subnormal1240 = and i1 %5137, %5139, !dbg !1096
  %5140 = xor i1 %is_subnormal1240, true, !dbg !1096
  %5141 = and i1 true, %5140, !dbg !1096
  %5142 = bitcast float %4565 to i32, !dbg !1096
  %5143 = and i32 %5142, 2139095040, !dbg !1096
  %5144 = icmp eq i32 %5143, 0, !dbg !1096
  %5145 = and i32 %5142, 8388607, !dbg !1096
  %5146 = icmp ne i32 %5145, 0, !dbg !1096
  %is_subnormal1241 = and i1 %5144, %5146, !dbg !1096
  %5147 = xor i1 %is_subnormal1241, true, !dbg !1096
  %5148 = and i1 %5141, %5147, !dbg !1096
  %5149 = and i1 %5148, true, !dbg !1096
  %5150 = bitcast float %5080 to i32, !dbg !1096
  %5151 = and i32 %5150, 2139095040, !dbg !1096
  %5152 = icmp eq i32 %5151, 0, !dbg !1096
  %5153 = and i32 %5150, 8388607, !dbg !1096
  %5154 = icmp ne i32 %5153, 0, !dbg !1096
  %is_subnormal1242 = and i1 %5152, %5154, !dbg !1096
  %subnormal_cond1243 = and i1 %5149, %is_subnormal1242, !dbg !1096
  br i1 %subnormal_cond1243, label %5155, label %5157, !dbg !1096

5155:                                             ; preds = %5134
  %5156 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5157, !dbg !1096

5157:                                             ; preds = %5134, %5155
  %5158 = bitcast float %5080 to i32, !dbg !1096
  %5159 = bitcast float %5080 to i32, !dbg !1096
  %5160 = and i32 %5159, 2139095040, !dbg !1096
  %5161 = icmp eq i32 %5160, 2139095040, !dbg !1096
  %5162 = and i32 %5159, 8388607, !dbg !1096
  %5163 = icmp ne i32 %5162, 0, !dbg !1096
  %is_nan1244 = and i1 %5161, %5163, !dbg !1096
  %5164 = and i32 %5158, 4194304, !dbg !1096
  %5165 = icmp eq i32 %5164, 0, !dbg !1096
  %is_snan1245 = and i1 %is_nan1244, %5165, !dbg !1096
  %5166 = bitcast float %4565 to i32, !dbg !1096
  %5167 = bitcast float %4565 to i32, !dbg !1096
  %5168 = and i32 %5167, 2139095040, !dbg !1096
  %5169 = icmp eq i32 %5168, 2139095040, !dbg !1096
  %5170 = and i32 %5167, 8388607, !dbg !1096
  %5171 = icmp ne i32 %5170, 0, !dbg !1096
  %is_nan1246 = and i1 %5169, %5171, !dbg !1096
  %5172 = and i32 %5166, 4194304, !dbg !1096
  %5173 = icmp eq i32 %5172, 0, !dbg !1096
  %is_snan1247 = and i1 %is_nan1246, %5173, !dbg !1096
  %5174 = or i1 %is_snan1245, %is_snan1247, !dbg !1096
  %5175 = or i1 %5174, false, !dbg !1096
  %5176 = bitcast float %5080 to i32, !dbg !1096
  %5177 = and i32 %5176, 2147483647, !dbg !1096
  %is_zero1248 = icmp eq i32 %5177, 0, !dbg !1096
  %5178 = bitcast float %4565 to i32, !dbg !1096
  %5179 = and i32 %5178, 2139095040, !dbg !1096
  %5180 = icmp eq i32 %5179, 2139095040, !dbg !1096
  %5181 = and i32 %5178, 8388607, !dbg !1096
  %5182 = icmp eq i32 %5181, 0, !dbg !1096
  %is_inf1249 = and i1 %5180, %5182, !dbg !1096
  %5183 = and i1 %is_zero1248, %is_inf1249, !dbg !1096
  %5184 = bitcast float %5080 to i32, !dbg !1096
  %5185 = and i32 %5184, 2139095040, !dbg !1096
  %5186 = icmp eq i32 %5185, 2139095040, !dbg !1096
  %5187 = and i32 %5184, 8388607, !dbg !1096
  %5188 = icmp eq i32 %5187, 0, !dbg !1096
  %is_inf1250 = and i1 %5186, %5188, !dbg !1096
  %5189 = bitcast float %4565 to i32, !dbg !1096
  %5190 = and i32 %5189, 2147483647, !dbg !1096
  %is_zero1251 = icmp eq i32 %5190, 0, !dbg !1096
  %5191 = and i1 %is_inf1250, %is_zero1251, !dbg !1096
  %5192 = or i1 %5183, %5191, !dbg !1096
  %5193 = or i1 %5175, %5192, !dbg !1096
  br i1 %5193, label %5194, label %5196, !dbg !1096

5194:                                             ; preds = %5157
  %5195 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5196, !dbg !1096

5196:                                             ; preds = %5157, %5194
  %5197 = call float @llvm.nvvm.fma.rn.f(float %5080, float %4565, float 1.000000e+00) #5, !dbg !1096
  %5198 = bitcast float %5080 to i32, !dbg !1096
  %5199 = and i32 %5198, 2139095040, !dbg !1096
  %is_finite1252 = icmp ne i32 %5199, 2139095040, !dbg !1096
  %5200 = and i1 true, %is_finite1252, !dbg !1096
  %5201 = bitcast float %4565 to i32, !dbg !1096
  %5202 = and i32 %5201, 2139095040, !dbg !1096
  %is_finite1253 = icmp ne i32 %5202, 2139095040, !dbg !1096
  %5203 = and i1 %5200, %is_finite1253, !dbg !1096
  %5204 = bitcast float %5197 to i32, !dbg !1096
  %5205 = and i32 %5204, 2139095040, !dbg !1096
  %5206 = icmp eq i32 %5205, 2139095040, !dbg !1096
  %5207 = and i32 %5204, 8388607, !dbg !1096
  %5208 = icmp eq i32 %5207, 0, !dbg !1096
  %is_inf1254 = and i1 %5206, %5208, !dbg !1096
  %5209 = bitcast float %5197 to i32, !dbg !1096
  %5210 = and i32 %5209, 2147483647, !dbg !1096
  %is_maxfinite1255 = icmp eq i32 %5210, 2139095039, !dbg !1096
  %5211 = bitcast float %5197 to i32, !dbg !1096
  %5212 = and i32 %5211, -2147483648, !dbg !1096
  %5213 = icmp eq i32 %5212, 0, !dbg !1096
  %5214 = icmp ne i32 %5212, 0, !dbg !1096
  %is_pos_inf1256 = and i1 %is_inf1254, %5213, !dbg !1096
  %is_neg_inf1257 = and i1 %is_inf1254, %5214, !dbg !1096
  %is_pos_max1258 = and i1 %is_maxfinite1255, %5213, !dbg !1096
  %is_neg_max1259 = and i1 %is_maxfinite1255, %5214, !dbg !1096
  %overflow_cond1260 = and i1 %5203, %is_inf1254, !dbg !1096
  br i1 %overflow_cond1260, label %5215, label %5217, !dbg !1096

5215:                                             ; preds = %5196
  %5216 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5217, !dbg !1096

5217:                                             ; preds = %5196, %5215
  %5218 = bitcast float %5080 to i32, !dbg !1096
  %5219 = and i32 %5218, 2139095040, !dbg !1096
  %5220 = icmp eq i32 %5219, 0, !dbg !1096
  %5221 = and i32 %5218, 8388607, !dbg !1096
  %5222 = icmp ne i32 %5221, 0, !dbg !1096
  %is_subnormal1261 = and i1 %5220, %5222, !dbg !1096
  %5223 = xor i1 %is_subnormal1261, true, !dbg !1096
  %5224 = and i1 true, %5223, !dbg !1096
  %5225 = bitcast float %4565 to i32, !dbg !1096
  %5226 = and i32 %5225, 2139095040, !dbg !1096
  %5227 = icmp eq i32 %5226, 0, !dbg !1096
  %5228 = and i32 %5225, 8388607, !dbg !1096
  %5229 = icmp ne i32 %5228, 0, !dbg !1096
  %is_subnormal1262 = and i1 %5227, %5229, !dbg !1096
  %5230 = xor i1 %is_subnormal1262, true, !dbg !1096
  %5231 = and i1 %5224, %5230, !dbg !1096
  %5232 = and i1 %5231, true, !dbg !1096
  %5233 = bitcast float %5197 to i32, !dbg !1096
  %5234 = and i32 %5233, 2139095040, !dbg !1096
  %5235 = icmp eq i32 %5234, 0, !dbg !1096
  %5236 = and i32 %5233, 8388607, !dbg !1096
  %5237 = icmp ne i32 %5236, 0, !dbg !1096
  %is_subnormal1263 = and i1 %5235, %5237, !dbg !1096
  %5238 = bitcast float %5197 to i32, !dbg !1096
  %5239 = and i32 %5238, 2147483647, !dbg !1096
  %is_zero1264 = icmp eq i32 %5239, 0, !dbg !1096
  %5240 = bitcast float %5080 to i32, !dbg !1096
  %5241 = and i32 %5240, 2147483647, !dbg !1096
  %is_zero1265 = icmp eq i32 %5241, 0, !dbg !1096
  %5242 = xor i1 %is_zero1265, true, !dbg !1096
  %5243 = bitcast float %4565 to i32, !dbg !1096
  %5244 = and i32 %5243, 2147483647, !dbg !1096
  %is_zero1266 = icmp eq i32 %5244, 0, !dbg !1096
  %5245 = xor i1 %is_zero1266, true, !dbg !1096
  %5246 = and i1 %5242, %5245, !dbg !1096
  %5247 = and i1 %5246, true, !dbg !1096
  %5248 = and i1 %is_zero1264, %5247, !dbg !1096
  %is_tiny1267 = or i1 %is_subnormal1263, %5248, !dbg !1096
  %underflow_cond1268 = and i1 %5232, %is_tiny1267, !dbg !1096
  br i1 %underflow_cond1268, label %5249, label %5251, !dbg !1096

5249:                                             ; preds = %5217
  %5250 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %5251, !dbg !1096

5251:                                             ; preds = %5217, %5249
  %5252 = bitcast float %5080 to i32, !dbg !1096
  %5253 = and i32 %5252, 2139095040, !dbg !1096
  %5254 = icmp eq i32 %5253, 0, !dbg !1096
  %5255 = and i32 %5252, 8388607, !dbg !1096
  %5256 = icmp ne i32 %5255, 0, !dbg !1096
  %is_subnormal1269 = and i1 %5254, %5256, !dbg !1096
  %5257 = xor i1 %is_subnormal1269, true, !dbg !1096
  %5258 = and i1 true, %5257, !dbg !1096
  %5259 = bitcast float %4565 to i32, !dbg !1096
  %5260 = and i32 %5259, 2139095040, !dbg !1096
  %5261 = icmp eq i32 %5260, 0, !dbg !1096
  %5262 = and i32 %5259, 8388607, !dbg !1096
  %5263 = icmp ne i32 %5262, 0, !dbg !1096
  %is_subnormal1270 = and i1 %5261, %5263, !dbg !1096
  %5264 = xor i1 %is_subnormal1270, true, !dbg !1096
  %5265 = and i1 %5258, %5264, !dbg !1096
  %5266 = and i1 %5265, true, !dbg !1096
  %5267 = bitcast float %5197 to i32, !dbg !1096
  %5268 = and i32 %5267, 2139095040, !dbg !1096
  %5269 = icmp eq i32 %5268, 0, !dbg !1096
  %5270 = and i32 %5267, 8388607, !dbg !1096
  %5271 = icmp ne i32 %5270, 0, !dbg !1096
  %is_subnormal1271 = and i1 %5269, %5271, !dbg !1096
  %subnormal_cond1272 = and i1 %5266, %is_subnormal1271, !dbg !1096
  br i1 %subnormal_cond1272, label %5272, label %5274, !dbg !1096

5272:                                             ; preds = %5251
  %5273 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5274, !dbg !1096

5274:                                             ; preds = %5251, %5272
  %5275 = fptosi float %4445 to i32, !dbg !1096
  %5276 = fcmp ogt float %4445, 0.000000e+00, !dbg !1096
  %5277 = select i1 %5276, i32 0, i32 -2097152000, !dbg !1096
  %5278 = add i32 2130706432, %5277, !dbg !1096
  %5279 = bitcast i32 %5278 to float, !dbg !1096
  %5280 = bitcast float %5197 to i32, !dbg !1096
  %5281 = bitcast float %5197 to i32, !dbg !1096
  %5282 = and i32 %5281, 2139095040, !dbg !1096
  %5283 = icmp eq i32 %5282, 2139095040, !dbg !1096
  %5284 = and i32 %5281, 8388607, !dbg !1096
  %5285 = icmp ne i32 %5284, 0, !dbg !1096
  %is_nan1273 = and i1 %5283, %5285, !dbg !1096
  %5286 = and i32 %5280, 4194304, !dbg !1096
  %5287 = icmp eq i32 %5286, 0, !dbg !1096
  %is_snan1274 = and i1 %is_nan1273, %5287, !dbg !1096
  %5288 = bitcast float %5279 to i32, !dbg !1096
  %5289 = bitcast float %5279 to i32, !dbg !1096
  %5290 = and i32 %5289, 2139095040, !dbg !1096
  %5291 = icmp eq i32 %5290, 2139095040, !dbg !1096
  %5292 = and i32 %5289, 8388607, !dbg !1096
  %5293 = icmp ne i32 %5292, 0, !dbg !1096
  %is_nan1275 = and i1 %5291, %5293, !dbg !1096
  %5294 = and i32 %5288, 4194304, !dbg !1096
  %5295 = icmp eq i32 %5294, 0, !dbg !1096
  %is_snan1276 = and i1 %is_nan1275, %5295, !dbg !1096
  %5296 = or i1 %is_snan1274, %is_snan1276, !dbg !1096
  %5297 = bitcast float %5197 to i32, !dbg !1096
  %5298 = and i32 %5297, 2147483647, !dbg !1096
  %is_zero1277 = icmp eq i32 %5298, 0, !dbg !1096
  %5299 = bitcast float %5279 to i32, !dbg !1096
  %5300 = and i32 %5299, 2139095040, !dbg !1096
  %5301 = icmp eq i32 %5300, 2139095040, !dbg !1096
  %5302 = and i32 %5299, 8388607, !dbg !1096
  %5303 = icmp eq i32 %5302, 0, !dbg !1096
  %is_inf1278 = and i1 %5301, %5303, !dbg !1096
  %5304 = and i1 %is_zero1277, %is_inf1278, !dbg !1096
  %5305 = bitcast float %5197 to i32, !dbg !1096
  %5306 = and i32 %5305, 2139095040, !dbg !1096
  %5307 = icmp eq i32 %5306, 2139095040, !dbg !1096
  %5308 = and i32 %5305, 8388607, !dbg !1096
  %5309 = icmp eq i32 %5308, 0, !dbg !1096
  %is_inf1279 = and i1 %5307, %5309, !dbg !1096
  %5310 = bitcast float %5279 to i32, !dbg !1096
  %5311 = and i32 %5310, 2147483647, !dbg !1096
  %is_zero1280 = icmp eq i32 %5311, 0, !dbg !1096
  %5312 = and i1 %is_inf1279, %is_zero1280, !dbg !1096
  %5313 = or i1 %5304, %5312, !dbg !1096
  %5314 = or i1 %5296, %5313, !dbg !1096
  br i1 %5314, label %5315, label %5317, !dbg !1096

5315:                                             ; preds = %5274
  %5316 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5317, !dbg !1096

5317:                                             ; preds = %5274, %5315
  %5318 = fmul float %5197, %5279, !dbg !1096
  %5319 = bitcast float %5197 to i32, !dbg !1096
  %5320 = and i32 %5319, 2139095040, !dbg !1096
  %is_finite1281 = icmp ne i32 %5320, 2139095040, !dbg !1096
  %5321 = and i1 true, %is_finite1281, !dbg !1096
  %5322 = bitcast float %5279 to i32, !dbg !1096
  %5323 = and i32 %5322, 2139095040, !dbg !1096
  %is_finite1282 = icmp ne i32 %5323, 2139095040, !dbg !1096
  %5324 = and i1 %5321, %is_finite1282, !dbg !1096
  %5325 = bitcast float %5318 to i32, !dbg !1096
  %5326 = and i32 %5325, 2139095040, !dbg !1096
  %5327 = icmp eq i32 %5326, 2139095040, !dbg !1096
  %5328 = and i32 %5325, 8388607, !dbg !1096
  %5329 = icmp eq i32 %5328, 0, !dbg !1096
  %is_inf1283 = and i1 %5327, %5329, !dbg !1096
  %5330 = bitcast float %5318 to i32, !dbg !1096
  %5331 = and i32 %5330, 2147483647, !dbg !1096
  %is_maxfinite1284 = icmp eq i32 %5331, 2139095039, !dbg !1096
  %5332 = bitcast float %5318 to i32, !dbg !1096
  %5333 = and i32 %5332, -2147483648, !dbg !1096
  %5334 = icmp eq i32 %5333, 0, !dbg !1096
  %5335 = icmp ne i32 %5333, 0, !dbg !1096
  %is_pos_inf1285 = and i1 %is_inf1283, %5334, !dbg !1096
  %is_neg_inf1286 = and i1 %is_inf1283, %5335, !dbg !1096
  %is_pos_max1287 = and i1 %is_maxfinite1284, %5334, !dbg !1096
  %is_neg_max1288 = and i1 %is_maxfinite1284, %5335, !dbg !1096
  %overflow_cond1289 = and i1 %5324, %is_inf1283, !dbg !1096
  br i1 %overflow_cond1289, label %5336, label %5338, !dbg !1096

5336:                                             ; preds = %5317
  %5337 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5338, !dbg !1096

5338:                                             ; preds = %5317, %5336
  %5339 = bitcast float %5197 to i32, !dbg !1096
  %5340 = and i32 %5339, 2139095040, !dbg !1096
  %5341 = icmp eq i32 %5340, 0, !dbg !1096
  %5342 = and i32 %5339, 8388607, !dbg !1096
  %5343 = icmp ne i32 %5342, 0, !dbg !1096
  %is_subnormal1290 = and i1 %5341, %5343, !dbg !1096
  %5344 = xor i1 %is_subnormal1290, true, !dbg !1096
  %5345 = and i1 true, %5344, !dbg !1096
  %5346 = bitcast float %5279 to i32, !dbg !1096
  %5347 = and i32 %5346, 2139095040, !dbg !1096
  %5348 = icmp eq i32 %5347, 0, !dbg !1096
  %5349 = and i32 %5346, 8388607, !dbg !1096
  %5350 = icmp ne i32 %5349, 0, !dbg !1096
  %is_subnormal1291 = and i1 %5348, %5350, !dbg !1096
  %5351 = xor i1 %is_subnormal1291, true, !dbg !1096
  %5352 = and i1 %5345, %5351, !dbg !1096
  %5353 = bitcast float %5318 to i32, !dbg !1096
  %5354 = and i32 %5353, 2139095040, !dbg !1096
  %5355 = icmp eq i32 %5354, 0, !dbg !1096
  %5356 = and i32 %5353, 8388607, !dbg !1096
  %5357 = icmp ne i32 %5356, 0, !dbg !1096
  %is_subnormal1292 = and i1 %5355, %5357, !dbg !1096
  %5358 = bitcast float %5318 to i32, !dbg !1096
  %5359 = and i32 %5358, 2147483647, !dbg !1096
  %is_zero1293 = icmp eq i32 %5359, 0, !dbg !1096
  %5360 = bitcast float %5197 to i32, !dbg !1096
  %5361 = and i32 %5360, 2147483647, !dbg !1096
  %is_zero1294 = icmp eq i32 %5361, 0, !dbg !1096
  %5362 = xor i1 %is_zero1294, true, !dbg !1096
  %5363 = bitcast float %5279 to i32, !dbg !1096
  %5364 = and i32 %5363, 2147483647, !dbg !1096
  %is_zero1295 = icmp eq i32 %5364, 0, !dbg !1096
  %5365 = xor i1 %is_zero1295, true, !dbg !1096
  %5366 = and i1 %5362, %5365, !dbg !1096
  %5367 = and i1 %is_zero1293, %5366, !dbg !1096
  %is_tiny1296 = or i1 %is_subnormal1292, %5367, !dbg !1096
  %underflow_cond1297 = and i1 %5352, %is_tiny1296, !dbg !1096
  br i1 %underflow_cond1297, label %5368, label %5370, !dbg !1096

5368:                                             ; preds = %5338
  %5369 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %5370, !dbg !1096

5370:                                             ; preds = %5338, %5368
  %5371 = bitcast float %5197 to i32, !dbg !1096
  %5372 = and i32 %5371, 2139095040, !dbg !1096
  %5373 = icmp eq i32 %5372, 0, !dbg !1096
  %5374 = and i32 %5371, 8388607, !dbg !1096
  %5375 = icmp ne i32 %5374, 0, !dbg !1096
  %is_subnormal1298 = and i1 %5373, %5375, !dbg !1096
  %5376 = xor i1 %is_subnormal1298, true, !dbg !1096
  %5377 = and i1 true, %5376, !dbg !1096
  %5378 = bitcast float %5279 to i32, !dbg !1096
  %5379 = and i32 %5378, 2139095040, !dbg !1096
  %5380 = icmp eq i32 %5379, 0, !dbg !1096
  %5381 = and i32 %5378, 8388607, !dbg !1096
  %5382 = icmp ne i32 %5381, 0, !dbg !1096
  %is_subnormal1299 = and i1 %5380, %5382, !dbg !1096
  %5383 = xor i1 %is_subnormal1299, true, !dbg !1096
  %5384 = and i1 %5377, %5383, !dbg !1096
  %5385 = bitcast float %5318 to i32, !dbg !1096
  %5386 = and i32 %5385, 2139095040, !dbg !1096
  %5387 = icmp eq i32 %5386, 0, !dbg !1096
  %5388 = and i32 %5385, 8388607, !dbg !1096
  %5389 = icmp ne i32 %5388, 0, !dbg !1096
  %is_subnormal1300 = and i1 %5387, %5389, !dbg !1096
  %subnormal_cond1301 = and i1 %5384, %is_subnormal1300, !dbg !1096
  br i1 %subnormal_cond1301, label %5390, label %5392, !dbg !1096

5390:                                             ; preds = %5370
  %5391 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5392, !dbg !1096

5392:                                             ; preds = %5370, %5390
  %5393 = shl i32 %5275, 23, !dbg !1096
  %5394 = sub i32 %5393, %5277, !dbg !1096
  %5395 = bitcast i32 %5394 to float, !dbg !1096
  %5396 = bitcast float %5318 to i32, !dbg !1096
  %5397 = bitcast float %5318 to i32, !dbg !1096
  %5398 = and i32 %5397, 2139095040, !dbg !1096
  %5399 = icmp eq i32 %5398, 2139095040, !dbg !1096
  %5400 = and i32 %5397, 8388607, !dbg !1096
  %5401 = icmp ne i32 %5400, 0, !dbg !1096
  %is_nan1302 = and i1 %5399, %5401, !dbg !1096
  %5402 = and i32 %5396, 4194304, !dbg !1096
  %5403 = icmp eq i32 %5402, 0, !dbg !1096
  %is_snan1303 = and i1 %is_nan1302, %5403, !dbg !1096
  %5404 = bitcast float %5395 to i32, !dbg !1096
  %5405 = bitcast float %5395 to i32, !dbg !1096
  %5406 = and i32 %5405, 2139095040, !dbg !1096
  %5407 = icmp eq i32 %5406, 2139095040, !dbg !1096
  %5408 = and i32 %5405, 8388607, !dbg !1096
  %5409 = icmp ne i32 %5408, 0, !dbg !1096
  %is_nan1304 = and i1 %5407, %5409, !dbg !1096
  %5410 = and i32 %5404, 4194304, !dbg !1096
  %5411 = icmp eq i32 %5410, 0, !dbg !1096
  %is_snan1305 = and i1 %is_nan1304, %5411, !dbg !1096
  %5412 = or i1 %is_snan1303, %is_snan1305, !dbg !1096
  %5413 = bitcast float %5318 to i32, !dbg !1096
  %5414 = and i32 %5413, 2147483647, !dbg !1096
  %is_zero1306 = icmp eq i32 %5414, 0, !dbg !1096
  %5415 = bitcast float %5395 to i32, !dbg !1096
  %5416 = and i32 %5415, 2139095040, !dbg !1096
  %5417 = icmp eq i32 %5416, 2139095040, !dbg !1096
  %5418 = and i32 %5415, 8388607, !dbg !1096
  %5419 = icmp eq i32 %5418, 0, !dbg !1096
  %is_inf1307 = and i1 %5417, %5419, !dbg !1096
  %5420 = and i1 %is_zero1306, %is_inf1307, !dbg !1096
  %5421 = bitcast float %5318 to i32, !dbg !1096
  %5422 = and i32 %5421, 2139095040, !dbg !1096
  %5423 = icmp eq i32 %5422, 2139095040, !dbg !1096
  %5424 = and i32 %5421, 8388607, !dbg !1096
  %5425 = icmp eq i32 %5424, 0, !dbg !1096
  %is_inf1308 = and i1 %5423, %5425, !dbg !1096
  %5426 = bitcast float %5395 to i32, !dbg !1096
  %5427 = and i32 %5426, 2147483647, !dbg !1096
  %is_zero1309 = icmp eq i32 %5427, 0, !dbg !1096
  %5428 = and i1 %is_inf1308, %is_zero1309, !dbg !1096
  %5429 = or i1 %5420, %5428, !dbg !1096
  %5430 = or i1 %5412, %5429, !dbg !1096
  br i1 %5430, label %5431, label %5433, !dbg !1096

5431:                                             ; preds = %5392
  %5432 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5433, !dbg !1096

5433:                                             ; preds = %5392, %5431
  %5434 = fmul float %5318, %5395, !dbg !1096
  %5435 = bitcast float %5318 to i32, !dbg !1096
  %5436 = and i32 %5435, 2139095040, !dbg !1096
  %is_finite1310 = icmp ne i32 %5436, 2139095040, !dbg !1096
  %5437 = and i1 true, %is_finite1310, !dbg !1096
  %5438 = bitcast float %5395 to i32, !dbg !1096
  %5439 = and i32 %5438, 2139095040, !dbg !1096
  %is_finite1311 = icmp ne i32 %5439, 2139095040, !dbg !1096
  %5440 = and i1 %5437, %is_finite1311, !dbg !1096
  %5441 = bitcast float %5434 to i32, !dbg !1096
  %5442 = and i32 %5441, 2139095040, !dbg !1096
  %5443 = icmp eq i32 %5442, 2139095040, !dbg !1096
  %5444 = and i32 %5441, 8388607, !dbg !1096
  %5445 = icmp eq i32 %5444, 0, !dbg !1096
  %is_inf1312 = and i1 %5443, %5445, !dbg !1096
  %5446 = bitcast float %5434 to i32, !dbg !1096
  %5447 = and i32 %5446, 2147483647, !dbg !1096
  %is_maxfinite1313 = icmp eq i32 %5447, 2139095039, !dbg !1096
  %5448 = bitcast float %5434 to i32, !dbg !1096
  %5449 = and i32 %5448, -2147483648, !dbg !1096
  %5450 = icmp eq i32 %5449, 0, !dbg !1096
  %5451 = icmp ne i32 %5449, 0, !dbg !1096
  %is_pos_inf1314 = and i1 %is_inf1312, %5450, !dbg !1096
  %is_neg_inf1315 = and i1 %is_inf1312, %5451, !dbg !1096
  %is_pos_max1316 = and i1 %is_maxfinite1313, %5450, !dbg !1096
  %is_neg_max1317 = and i1 %is_maxfinite1313, %5451, !dbg !1096
  %overflow_cond1318 = and i1 %5440, %is_inf1312, !dbg !1096
  br i1 %overflow_cond1318, label %5452, label %5454, !dbg !1096

5452:                                             ; preds = %5433
  %5453 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5454, !dbg !1096

5454:                                             ; preds = %5433, %5452
  %5455 = bitcast float %5318 to i32, !dbg !1096
  %5456 = and i32 %5455, 2139095040, !dbg !1096
  %5457 = icmp eq i32 %5456, 0, !dbg !1096
  %5458 = and i32 %5455, 8388607, !dbg !1096
  %5459 = icmp ne i32 %5458, 0, !dbg !1096
  %is_subnormal1319 = and i1 %5457, %5459, !dbg !1096
  %5460 = xor i1 %is_subnormal1319, true, !dbg !1096
  %5461 = and i1 true, %5460, !dbg !1096
  %5462 = bitcast float %5395 to i32, !dbg !1096
  %5463 = and i32 %5462, 2139095040, !dbg !1096
  %5464 = icmp eq i32 %5463, 0, !dbg !1096
  %5465 = and i32 %5462, 8388607, !dbg !1096
  %5466 = icmp ne i32 %5465, 0, !dbg !1096
  %is_subnormal1320 = and i1 %5464, %5466, !dbg !1096
  %5467 = xor i1 %is_subnormal1320, true, !dbg !1096
  %5468 = and i1 %5461, %5467, !dbg !1096
  %5469 = bitcast float %5434 to i32, !dbg !1096
  %5470 = and i32 %5469, 2139095040, !dbg !1096
  %5471 = icmp eq i32 %5470, 0, !dbg !1096
  %5472 = and i32 %5469, 8388607, !dbg !1096
  %5473 = icmp ne i32 %5472, 0, !dbg !1096
  %is_subnormal1321 = and i1 %5471, %5473, !dbg !1096
  %5474 = bitcast float %5434 to i32, !dbg !1096
  %5475 = and i32 %5474, 2147483647, !dbg !1096
  %is_zero1322 = icmp eq i32 %5475, 0, !dbg !1096
  %5476 = bitcast float %5318 to i32, !dbg !1096
  %5477 = and i32 %5476, 2147483647, !dbg !1096
  %is_zero1323 = icmp eq i32 %5477, 0, !dbg !1096
  %5478 = xor i1 %is_zero1323, true, !dbg !1096
  %5479 = bitcast float %5395 to i32, !dbg !1096
  %5480 = and i32 %5479, 2147483647, !dbg !1096
  %is_zero1324 = icmp eq i32 %5480, 0, !dbg !1096
  %5481 = xor i1 %is_zero1324, true, !dbg !1096
  %5482 = and i1 %5478, %5481, !dbg !1096
  %5483 = and i1 %is_zero1322, %5482, !dbg !1096
  %is_tiny1325 = or i1 %is_subnormal1321, %5483, !dbg !1096
  %underflow_cond1326 = and i1 %5468, %is_tiny1325, !dbg !1096
  br i1 %underflow_cond1326, label %5484, label %5486, !dbg !1096

5484:                                             ; preds = %5454
  %5485 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1096
  br label %5486, !dbg !1096

5486:                                             ; preds = %5454, %5484
  %5487 = bitcast float %5318 to i32, !dbg !1096
  %5488 = and i32 %5487, 2139095040, !dbg !1096
  %5489 = icmp eq i32 %5488, 0, !dbg !1096
  %5490 = and i32 %5487, 8388607, !dbg !1096
  %5491 = icmp ne i32 %5490, 0, !dbg !1096
  %is_subnormal1327 = and i1 %5489, %5491, !dbg !1096
  %5492 = xor i1 %is_subnormal1327, true, !dbg !1096
  %5493 = and i1 true, %5492, !dbg !1096
  %5494 = bitcast float %5395 to i32, !dbg !1096
  %5495 = and i32 %5494, 2139095040, !dbg !1096
  %5496 = icmp eq i32 %5495, 0, !dbg !1096
  %5497 = and i32 %5494, 8388607, !dbg !1096
  %5498 = icmp ne i32 %5497, 0, !dbg !1096
  %is_subnormal1328 = and i1 %5496, %5498, !dbg !1096
  %5499 = xor i1 %is_subnormal1328, true, !dbg !1096
  %5500 = and i1 %5493, %5499, !dbg !1096
  %5501 = bitcast float %5434 to i32, !dbg !1096
  %5502 = and i32 %5501, 2139095040, !dbg !1096
  %5503 = icmp eq i32 %5502, 0, !dbg !1096
  %5504 = and i32 %5501, 8388607, !dbg !1096
  %5505 = icmp ne i32 %5504, 0, !dbg !1096
  %is_subnormal1329 = and i1 %5503, %5505, !dbg !1096
  %subnormal_cond1330 = and i1 %5500, %is_subnormal1329, !dbg !1096
  br i1 %subnormal_cond1330, label %5506, label %5508, !dbg !1096

5506:                                             ; preds = %5486
  %5507 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5508, !dbg !1096

5508:                                             ; preds = %5486, %5506
  %5509 = call float @llvm.nvvm.fabs.f32(float %4034), !dbg !1096
  %5510 = fcmp ogt float %5509, 1.520000e+02, !dbg !1096
  br i1 %5510, label %5511, label %__internal_accurate_powf.exit.i, !dbg !1096

5511:                                             ; preds = %5508
  %5512 = fcmp olt float %4034, 0.000000e+00, !dbg !1096
  br i1 %5512, label %5513, label %5514, !dbg !1096

5513:                                             ; preds = %5511
  br label %5515, !dbg !1096

5514:                                             ; preds = %5511
  br label %5515, !dbg !1096

5515:                                             ; preds = %5514, %5513
  %5516 = phi float [ 0.000000e+00, %5513 ], [ 0x7FF0000000000000, %5514 ], !dbg !1096
  br label %__internal_accurate_powf.exit.i, !dbg !1096

__internal_accurate_powf.exit.i:                  ; preds = %5515, %5508
  %t.i.0.i = phi float [ %5516, %5515 ], [ %5434, %5508 ], !dbg !1096
  %5517 = fcmp oeq float %1009, 1.000000e+00, !dbg !1096
  br i1 %5517, label %5520, label %5518, !dbg !1096

5518:                                             ; preds = %__internal_accurate_powf.exit.i
  %5519 = fcmp oeq float %1010, 0.000000e+00, !dbg !1096
  br i1 %5519, label %5520, label %5521, !dbg !1096

5520:                                             ; preds = %5518, %__internal_accurate_powf.exit.i
  br label %__nv_powf.exit, !dbg !1096

5521:                                             ; preds = %5518
  %5522 = call float @llvm.nvvm.fabs.f32(float %1009), !dbg !1096
  %5523 = fcmp ole float %5522, 0x7FF0000000000000, !dbg !1096
  %5524 = xor i1 %5523, true, !dbg !1096
  %5525 = select i1 %5524, i32 1, i32 0, !dbg !1096
  br i1 %5524, label %5531, label %5526, !dbg !1096

5526:                                             ; preds = %5521
  %5527 = call float @llvm.nvvm.fabs.f32(float %1010), !dbg !1096
  %5528 = fcmp ole float %5527, 0x7FF0000000000000, !dbg !1096
  %5529 = xor i1 %5528, true, !dbg !1096
  %5530 = select i1 %5529, i32 1, i32 0, !dbg !1096
  br i1 %5529, label %5531, label %5613, !dbg !1096

5531:                                             ; preds = %5526, %5521
  %5532 = bitcast float %1009 to i32, !dbg !1096
  %5533 = bitcast float %1009 to i32, !dbg !1096
  %5534 = and i32 %5533, 2139095040, !dbg !1096
  %5535 = icmp eq i32 %5534, 2139095040, !dbg !1096
  %5536 = and i32 %5533, 8388607, !dbg !1096
  %5537 = icmp ne i32 %5536, 0, !dbg !1096
  %is_nan1331 = and i1 %5535, %5537, !dbg !1096
  %5538 = and i32 %5532, 4194304, !dbg !1096
  %5539 = icmp eq i32 %5538, 0, !dbg !1096
  %is_snan1332 = and i1 %is_nan1331, %5539, !dbg !1096
  %5540 = bitcast float %1010 to i32, !dbg !1096
  %5541 = bitcast float %1010 to i32, !dbg !1096
  %5542 = and i32 %5541, 2139095040, !dbg !1096
  %5543 = icmp eq i32 %5542, 2139095040, !dbg !1096
  %5544 = and i32 %5541, 8388607, !dbg !1096
  %5545 = icmp ne i32 %5544, 0, !dbg !1096
  %is_nan1333 = and i1 %5543, %5545, !dbg !1096
  %5546 = and i32 %5540, 4194304, !dbg !1096
  %5547 = icmp eq i32 %5546, 0, !dbg !1096
  %is_snan1334 = and i1 %is_nan1333, %5547, !dbg !1096
  %5548 = or i1 %is_snan1332, %is_snan1334, !dbg !1096
  %5549 = bitcast float %1009 to i32, !dbg !1096
  %5550 = and i32 %5549, 2139095040, !dbg !1096
  %5551 = icmp eq i32 %5550, 2139095040, !dbg !1096
  %5552 = and i32 %5549, 8388607, !dbg !1096
  %5553 = icmp eq i32 %5552, 0, !dbg !1096
  %is_inf1335 = and i1 %5551, %5553, !dbg !1096
  %5554 = bitcast float %1010 to i32, !dbg !1096
  %5555 = and i32 %5554, 2139095040, !dbg !1096
  %5556 = icmp eq i32 %5555, 2139095040, !dbg !1096
  %5557 = and i32 %5554, 8388607, !dbg !1096
  %5558 = icmp eq i32 %5557, 0, !dbg !1096
  %is_inf1336 = and i1 %5556, %5558, !dbg !1096
  %5559 = and i1 %is_inf1335, %is_inf1336, !dbg !1096
  %5560 = bitcast float %1009 to i32, !dbg !1096
  %5561 = bitcast float %1010 to i32, !dbg !1096
  %5562 = and i32 %5560, -2147483648, !dbg !1096
  %5563 = and i32 %5561, -2147483648, !dbg !1096
  %5564 = icmp ne i32 %5562, %5563, !dbg !1096
  %5565 = and i1 %5559, %5564, !dbg !1096
  %5566 = or i1 %5548, %5565, !dbg !1096
  br i1 %5566, label %5567, label %5569, !dbg !1096

5567:                                             ; preds = %5531
  %5568 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5569, !dbg !1096

5569:                                             ; preds = %5531, %5567
  %5570 = call float @llvm.nvvm.add.rn.f(float %1009, float %1010) #5, !dbg !1096
  %5571 = bitcast float %1009 to i32, !dbg !1096
  %5572 = and i32 %5571, 2139095040, !dbg !1096
  %is_finite1337 = icmp ne i32 %5572, 2139095040, !dbg !1096
  %5573 = and i1 true, %is_finite1337, !dbg !1096
  %5574 = bitcast float %1010 to i32, !dbg !1096
  %5575 = and i32 %5574, 2139095040, !dbg !1096
  %is_finite1338 = icmp ne i32 %5575, 2139095040, !dbg !1096
  %5576 = and i1 %5573, %is_finite1338, !dbg !1096
  %5577 = bitcast float %5570 to i32, !dbg !1096
  %5578 = and i32 %5577, 2139095040, !dbg !1096
  %5579 = icmp eq i32 %5578, 2139095040, !dbg !1096
  %5580 = and i32 %5577, 8388607, !dbg !1096
  %5581 = icmp eq i32 %5580, 0, !dbg !1096
  %is_inf1339 = and i1 %5579, %5581, !dbg !1096
  %5582 = bitcast float %5570 to i32, !dbg !1096
  %5583 = and i32 %5582, 2147483647, !dbg !1096
  %is_maxfinite1340 = icmp eq i32 %5583, 2139095039, !dbg !1096
  %5584 = bitcast float %5570 to i32, !dbg !1096
  %5585 = and i32 %5584, -2147483648, !dbg !1096
  %5586 = icmp eq i32 %5585, 0, !dbg !1096
  %5587 = icmp ne i32 %5585, 0, !dbg !1096
  %is_pos_inf1341 = and i1 %is_inf1339, %5586, !dbg !1096
  %is_neg_inf1342 = and i1 %is_inf1339, %5587, !dbg !1096
  %is_pos_max1343 = and i1 %is_maxfinite1340, %5586, !dbg !1096
  %is_neg_max1344 = and i1 %is_maxfinite1340, %5587, !dbg !1096
  %overflow_cond1345 = and i1 %5576, %is_inf1339, !dbg !1096
  br i1 %overflow_cond1345, label %5588, label %5590, !dbg !1096

5588:                                             ; preds = %5569
  %5589 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5590, !dbg !1096

5590:                                             ; preds = %5569, %5588
  %5591 = bitcast float %1009 to i32, !dbg !1096
  %5592 = and i32 %5591, 2139095040, !dbg !1096
  %5593 = icmp eq i32 %5592, 0, !dbg !1096
  %5594 = and i32 %5591, 8388607, !dbg !1096
  %5595 = icmp ne i32 %5594, 0, !dbg !1096
  %is_subnormal1346 = and i1 %5593, %5595, !dbg !1096
  %5596 = xor i1 %is_subnormal1346, true, !dbg !1096
  %5597 = and i1 true, %5596, !dbg !1096
  %5598 = bitcast float %1010 to i32, !dbg !1096
  %5599 = and i32 %5598, 2139095040, !dbg !1096
  %5600 = icmp eq i32 %5599, 0, !dbg !1096
  %5601 = and i32 %5598, 8388607, !dbg !1096
  %5602 = icmp ne i32 %5601, 0, !dbg !1096
  %is_subnormal1347 = and i1 %5600, %5602, !dbg !1096
  %5603 = xor i1 %is_subnormal1347, true, !dbg !1096
  %5604 = and i1 %5597, %5603, !dbg !1096
  %5605 = bitcast float %5570 to i32, !dbg !1096
  %5606 = and i32 %5605, 2139095040, !dbg !1096
  %5607 = icmp eq i32 %5606, 0, !dbg !1096
  %5608 = and i32 %5605, 8388607, !dbg !1096
  %5609 = icmp ne i32 %5608, 0, !dbg !1096
  %is_subnormal1348 = and i1 %5607, %5609, !dbg !1096
  %subnormal_cond1349 = and i1 %5604, %is_subnormal1348, !dbg !1096
  br i1 %subnormal_cond1349, label %5610, label %5612, !dbg !1096

5610:                                             ; preds = %5590
  %5611 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5612, !dbg !1096

5612:                                             ; preds = %5590, %5610
  br label %5786, !dbg !1096

5613:                                             ; preds = %5526
  %5614 = fcmp oeq float %1009, 0.000000e+00, !dbg !1096
  br i1 %5614, label %5619, label %5615, !dbg !1096

5615:                                             ; preds = %5613
  %5616 = call float @llvm.nvvm.fabs.f32(float %1009), !dbg !1096
  %5617 = fcmp oeq float %5616, 0x7FF0000000000000, !dbg !1096
  %5618 = select i1 %5617, i32 1, i32 0, !dbg !1096
  br i1 %5617, label %5619, label %5711, !dbg !1096

5619:                                             ; preds = %5615, %5613
  %5620 = bitcast float %1009 to i32, !dbg !1096
  %5621 = bitcast float %1009 to i32, !dbg !1096
  %5622 = and i32 %5621, 2139095040, !dbg !1096
  %5623 = icmp eq i32 %5622, 2139095040, !dbg !1096
  %5624 = and i32 %5621, 8388607, !dbg !1096
  %5625 = icmp ne i32 %5624, 0, !dbg !1096
  %is_nan1350 = and i1 %5623, %5625, !dbg !1096
  %5626 = and i32 %5620, 4194304, !dbg !1096
  %5627 = icmp eq i32 %5626, 0, !dbg !1096
  %is_snan1351 = and i1 %is_nan1350, %5627, !dbg !1096
  %5628 = bitcast float %1009 to i32, !dbg !1096
  %5629 = bitcast float %1009 to i32, !dbg !1096
  %5630 = and i32 %5629, 2139095040, !dbg !1096
  %5631 = icmp eq i32 %5630, 2139095040, !dbg !1096
  %5632 = and i32 %5629, 8388607, !dbg !1096
  %5633 = icmp ne i32 %5632, 0, !dbg !1096
  %is_nan1352 = and i1 %5631, %5633, !dbg !1096
  %5634 = and i32 %5628, 4194304, !dbg !1096
  %5635 = icmp eq i32 %5634, 0, !dbg !1096
  %is_snan1353 = and i1 %is_nan1352, %5635, !dbg !1096
  %5636 = or i1 %is_snan1351, %is_snan1353, !dbg !1096
  %5637 = bitcast float %1009 to i32, !dbg !1096
  %5638 = and i32 %5637, 2139095040, !dbg !1096
  %5639 = icmp eq i32 %5638, 2139095040, !dbg !1096
  %5640 = and i32 %5637, 8388607, !dbg !1096
  %5641 = icmp eq i32 %5640, 0, !dbg !1096
  %is_inf1354 = and i1 %5639, %5641, !dbg !1096
  %5642 = bitcast float %1009 to i32, !dbg !1096
  %5643 = and i32 %5642, 2139095040, !dbg !1096
  %5644 = icmp eq i32 %5643, 2139095040, !dbg !1096
  %5645 = and i32 %5642, 8388607, !dbg !1096
  %5646 = icmp eq i32 %5645, 0, !dbg !1096
  %is_inf1355 = and i1 %5644, %5646, !dbg !1096
  %5647 = and i1 %is_inf1354, %is_inf1355, !dbg !1096
  %5648 = bitcast float %1009 to i32, !dbg !1096
  %5649 = bitcast float %1009 to i32, !dbg !1096
  %5650 = and i32 %5648, -2147483648, !dbg !1096
  %5651 = and i32 %5649, -2147483648, !dbg !1096
  %5652 = icmp ne i32 %5650, %5651, !dbg !1096
  %5653 = and i1 %5647, %5652, !dbg !1096
  %5654 = or i1 %5636, %5653, !dbg !1096
  br i1 %5654, label %5655, label %5657, !dbg !1096

5655:                                             ; preds = %5619
  %5656 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5657, !dbg !1096

5657:                                             ; preds = %5619, %5655
  %5658 = fadd float %1009, %1009, !dbg !1096
  %5659 = bitcast float %1009 to i32, !dbg !1096
  %5660 = and i32 %5659, 2139095040, !dbg !1096
  %is_finite1356 = icmp ne i32 %5660, 2139095040, !dbg !1096
  %5661 = and i1 true, %is_finite1356, !dbg !1096
  %5662 = bitcast float %1009 to i32, !dbg !1096
  %5663 = and i32 %5662, 2139095040, !dbg !1096
  %is_finite1357 = icmp ne i32 %5663, 2139095040, !dbg !1096
  %5664 = and i1 %5661, %is_finite1357, !dbg !1096
  %5665 = bitcast float %5658 to i32, !dbg !1096
  %5666 = and i32 %5665, 2139095040, !dbg !1096
  %5667 = icmp eq i32 %5666, 2139095040, !dbg !1096
  %5668 = and i32 %5665, 8388607, !dbg !1096
  %5669 = icmp eq i32 %5668, 0, !dbg !1096
  %is_inf1358 = and i1 %5667, %5669, !dbg !1096
  %5670 = bitcast float %5658 to i32, !dbg !1096
  %5671 = and i32 %5670, 2147483647, !dbg !1096
  %is_maxfinite1359 = icmp eq i32 %5671, 2139095039, !dbg !1096
  %5672 = bitcast float %5658 to i32, !dbg !1096
  %5673 = and i32 %5672, -2147483648, !dbg !1096
  %5674 = icmp eq i32 %5673, 0, !dbg !1096
  %5675 = icmp ne i32 %5673, 0, !dbg !1096
  %is_pos_inf1360 = and i1 %is_inf1358, %5674, !dbg !1096
  %is_neg_inf1361 = and i1 %is_inf1358, %5675, !dbg !1096
  %is_pos_max1362 = and i1 %is_maxfinite1359, %5674, !dbg !1096
  %is_neg_max1363 = and i1 %is_maxfinite1359, %5675, !dbg !1096
  %overflow_cond1364 = and i1 %5664, %is_inf1358, !dbg !1096
  br i1 %overflow_cond1364, label %5676, label %5678, !dbg !1096

5676:                                             ; preds = %5657
  %5677 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5678, !dbg !1096

5678:                                             ; preds = %5657, %5676
  %5679 = bitcast float %1009 to i32, !dbg !1096
  %5680 = and i32 %5679, 2139095040, !dbg !1096
  %5681 = icmp eq i32 %5680, 0, !dbg !1096
  %5682 = and i32 %5679, 8388607, !dbg !1096
  %5683 = icmp ne i32 %5682, 0, !dbg !1096
  %is_subnormal1365 = and i1 %5681, %5683, !dbg !1096
  %5684 = xor i1 %is_subnormal1365, true, !dbg !1096
  %5685 = and i1 true, %5684, !dbg !1096
  %5686 = bitcast float %1009 to i32, !dbg !1096
  %5687 = and i32 %5686, 2139095040, !dbg !1096
  %5688 = icmp eq i32 %5687, 0, !dbg !1096
  %5689 = and i32 %5686, 8388607, !dbg !1096
  %5690 = icmp ne i32 %5689, 0, !dbg !1096
  %is_subnormal1366 = and i1 %5688, %5690, !dbg !1096
  %5691 = xor i1 %is_subnormal1366, true, !dbg !1096
  %5692 = and i1 %5685, %5691, !dbg !1096
  %5693 = bitcast float %5658 to i32, !dbg !1096
  %5694 = and i32 %5693, 2139095040, !dbg !1096
  %5695 = icmp eq i32 %5694, 0, !dbg !1096
  %5696 = and i32 %5693, 8388607, !dbg !1096
  %5697 = icmp ne i32 %5696, 0, !dbg !1096
  %is_subnormal1367 = and i1 %5695, %5697, !dbg !1096
  %subnormal_cond1368 = and i1 %5692, %is_subnormal1367, !dbg !1096
  br i1 %subnormal_cond1368, label %5698, label %5700, !dbg !1096

5698:                                             ; preds = %5678
  %5699 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5700, !dbg !1096

5700:                                             ; preds = %5678, %5698
  %5701 = bitcast float %5658 to i32, !dbg !1096
  %5702 = fcmp olt float %1010, 0.000000e+00, !dbg !1096
  br i1 %5702, label %5703, label %5705, !dbg !1096

5703:                                             ; preds = %5700
  %5704 = xor i32 %5701, 2139095040, !dbg !1096
  br label %5705, !dbg !1096

5705:                                             ; preds = %5703, %5700
  %ti.i.0.i = phi i32 [ %5704, %5703 ], [ %5701, %5700 ], !dbg !1096
  %5706 = icmp eq i32 %1251, 0, !dbg !1096
  br i1 %5706, label %5707, label %5709, !dbg !1096

5707:                                             ; preds = %5705
  %5708 = and i32 %ti.i.0.i, 2147483647, !dbg !1096
  br label %5709, !dbg !1096

5709:                                             ; preds = %5707, %5705
  %ti.i.1.i = phi i32 [ %5708, %5707 ], [ %ti.i.0.i, %5705 ], !dbg !1096
  %5710 = bitcast i32 %ti.i.1.i to float, !dbg !1096
  br label %5785, !dbg !1096

5711:                                             ; preds = %5615
  %5712 = fcmp oeq float %1009, -1.000000e+00, !dbg !1096
  br i1 %5712, label %5713, label %5718, !dbg !1096

5713:                                             ; preds = %5711
  %5714 = call float @llvm.nvvm.fabs.f32(float %1010), !dbg !1096
  %5715 = fcmp oeq float %5714, 0x7FF0000000000000, !dbg !1096
  %5716 = select i1 %5715, i32 1, i32 0, !dbg !1096
  br i1 %5715, label %5717, label %5718, !dbg !1096

5717:                                             ; preds = %5713
  br label %5784, !dbg !1096

5718:                                             ; preds = %5713, %5711
  %5719 = fcmp olt float %1009, 0.000000e+00, !dbg !1096
  br i1 %5719, label %5720, label %5783, !dbg !1096

5720:                                             ; preds = %5718
  br i1 %1250, label %5721, label %5778, !dbg !1096

5721:                                             ; preds = %5720
  %5722 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5723 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5724 = and i32 %5723, 2139095040, !dbg !1096
  %5725 = icmp eq i32 %5724, 2139095040, !dbg !1096
  %5726 = and i32 %5723, 8388607, !dbg !1096
  %5727 = icmp ne i32 %5726, 0, !dbg !1096
  %is_nan1369 = and i1 %5725, %5727, !dbg !1096
  %5728 = and i32 %5722, 4194304, !dbg !1096
  %5729 = icmp eq i32 %5728, 0, !dbg !1096
  %is_snan1370 = and i1 %is_nan1369, %5729, !dbg !1096
  %5730 = or i1 false, %is_snan1370, !dbg !1096
  %5731 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5732 = and i32 %5731, 2139095040, !dbg !1096
  %5733 = icmp eq i32 %5732, 2139095040, !dbg !1096
  %5734 = and i32 %5731, 8388607, !dbg !1096
  %5735 = icmp eq i32 %5734, 0, !dbg !1096
  %is_inf1371 = and i1 %5733, %5735, !dbg !1096
  %5736 = and i1 false, %is_inf1371, !dbg !1096
  %5737 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5738 = and i32 %5737, -2147483648, !dbg !1096
  %5739 = icmp eq i32 -2147483648, %5738, !dbg !1096
  %5740 = and i1 %5736, %5739, !dbg !1096
  %5741 = or i1 %5730, %5740, !dbg !1096
  br i1 %5741, label %5742, label %5744, !dbg !1096

5742:                                             ; preds = %5721
  %5743 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1096
  br label %5744, !dbg !1096

5744:                                             ; preds = %5721, %5742
  %5745 = fsub float -0.000000e+00, %t.i.0.i, !dbg !1096
  %5746 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5747 = and i32 %5746, 2139095040, !dbg !1096
  %is_finite1372 = icmp ne i32 %5747, 2139095040, !dbg !1096
  %5748 = and i1 true, %is_finite1372, !dbg !1096
  %5749 = bitcast float %5745 to i32, !dbg !1096
  %5750 = and i32 %5749, 2139095040, !dbg !1096
  %5751 = icmp eq i32 %5750, 2139095040, !dbg !1096
  %5752 = and i32 %5749, 8388607, !dbg !1096
  %5753 = icmp eq i32 %5752, 0, !dbg !1096
  %is_inf1373 = and i1 %5751, %5753, !dbg !1096
  %5754 = bitcast float %5745 to i32, !dbg !1096
  %5755 = and i32 %5754, 2147483647, !dbg !1096
  %is_maxfinite1374 = icmp eq i32 %5755, 2139095039, !dbg !1096
  %5756 = bitcast float %5745 to i32, !dbg !1096
  %5757 = and i32 %5756, -2147483648, !dbg !1096
  %5758 = icmp eq i32 %5757, 0, !dbg !1096
  %5759 = icmp ne i32 %5757, 0, !dbg !1096
  %is_pos_inf1375 = and i1 %is_inf1373, %5758, !dbg !1096
  %is_neg_inf1376 = and i1 %is_inf1373, %5759, !dbg !1096
  %is_pos_max1377 = and i1 %is_maxfinite1374, %5758, !dbg !1096
  %is_neg_max1378 = and i1 %is_maxfinite1374, %5759, !dbg !1096
  %overflow_cond1379 = and i1 %5748, %is_inf1373, !dbg !1096
  br i1 %overflow_cond1379, label %5760, label %5762, !dbg !1096

5760:                                             ; preds = %5744
  %5761 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1096
  br label %5762, !dbg !1096

5762:                                             ; preds = %5744, %5760
  %5763 = bitcast float %t.i.0.i to i32, !dbg !1096
  %5764 = and i32 %5763, 2139095040, !dbg !1096
  %5765 = icmp eq i32 %5764, 0, !dbg !1096
  %5766 = and i32 %5763, 8388607, !dbg !1096
  %5767 = icmp ne i32 %5766, 0, !dbg !1096
  %is_subnormal1380 = and i1 %5765, %5767, !dbg !1096
  %5768 = xor i1 %is_subnormal1380, true, !dbg !1096
  %5769 = and i1 true, %5768, !dbg !1096
  %5770 = bitcast float %5745 to i32, !dbg !1096
  %5771 = and i32 %5770, 2139095040, !dbg !1096
  %5772 = icmp eq i32 %5771, 0, !dbg !1096
  %5773 = and i32 %5770, 8388607, !dbg !1096
  %5774 = icmp ne i32 %5773, 0, !dbg !1096
  %is_subnormal1381 = and i1 %5772, %5774, !dbg !1096
  %subnormal_cond1382 = and i1 %5769, %is_subnormal1381, !dbg !1096
  br i1 %subnormal_cond1382, label %5775, label %5777, !dbg !1096

5775:                                             ; preds = %5762
  %5776 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1096
  br label %5777, !dbg !1096

5777:                                             ; preds = %5762, %5775
  br label %5778, !dbg !1096

5778:                                             ; preds = %5777, %5720
  %.01.i = phi float [ %5745, %5777 ], [ %t.i.0.i, %5720 ], !dbg !1096
  %5779 = call float @llvm.nvvm.floor.f(float %1010) #5, !dbg !1096
  %5780 = fcmp une float %1010, %5779, !dbg !1096
  br i1 %5780, label %5781, label %5782, !dbg !1096

5781:                                             ; preds = %5778
  br label %5782, !dbg !1096

5782:                                             ; preds = %5781, %5778
  %.1.i = phi float [ 0x7FFFFFFFE0000000, %5781 ], [ %.01.i, %5778 ], !dbg !1096
  br label %5783, !dbg !1096

5783:                                             ; preds = %5782, %5718
  %.2.i = phi float [ %.1.i, %5782 ], [ %t.i.0.i, %5718 ], !dbg !1096
  br label %5784, !dbg !1096

5784:                                             ; preds = %5783, %5717
  %.3.i = phi float [ 1.000000e+00, %5717 ], [ %.2.i, %5783 ], !dbg !1096
  br label %5785, !dbg !1096

5785:                                             ; preds = %5784, %5709
  %.4.i = phi float [ %5710, %5709 ], [ %.3.i, %5784 ], !dbg !1096
  br label %5786, !dbg !1096

5786:                                             ; preds = %5785, %5612
  %.5.i = phi float [ %5570, %5612 ], [ %.4.i, %5785 ], !dbg !1096
  br label %__nv_powf.exit, !dbg !1096

__nv_powf.exit:                                   ; preds = %5520, %5786
  %.6.i = phi float [ 1.000000e+00, %5520 ], [ %.5.i, %5786 ], !dbg !1096
  %5787 = load ptr, ptr %result.addr, align 8, !dbg !1098
  %arrayidx49 = getelementptr inbounds float, ptr %5787, i64 6, !dbg !1098
  store float %.6.i, ptr %arrayidx49, align 4, !dbg !1099
  %5788 = load ptr, ptr %result.addr, align 8, !dbg !1100
  %arrayidx50 = getelementptr inbounds float, ptr %5788, i64 6, !dbg !1100
  %5789 = load float, ptr %arrayidx50, align 4, !dbg !1100
  %call51 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %5789) #4, !dbg !1101
  %5790 = zext i1 %call51 to i64, !dbg !1101
  %cond52 = select i1 %call51, i32 1, i32 0, !dbg !1101
  %5791 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1102
  %arrayidx53 = getelementptr inbounds i32, ptr %5791, i64 6, !dbg !1102
  store i32 %cond52, ptr %arrayidx53, align 4, !dbg !1103
  br label %if.end54, !dbg !1104

if.end54:                                         ; preds = %__nv_powf.exit, %if.end45
  %5792 = load i32, ptr %idx, align 4, !dbg !1105
  %cmp55 = icmp eq i32 %5792, 7, !dbg !1107
  br i1 %cmp55, label %if.then56, label %if.end63, !dbg !1107

if.then56:                                        ; preds = %if.end54
  store float 1.000000e+00, ptr %__a.addr.i68, align 4
    #dbg_declare(ptr %__a.addr.i68, !1108, !DIExpression(), !1109)
  %5793 = load float, ptr %__a.addr.i68, align 4, !dbg !1112
  %5794 = fcmp olt float %5793, 0x3810000000000000, !dbg !1113
  br i1 %5794, label %5795, label %5877, !dbg !1113

5795:                                             ; preds = %if.then56
  %5796 = bitcast float %5793 to i32, !dbg !1113
  %5797 = bitcast float %5793 to i32, !dbg !1113
  %5798 = and i32 %5797, 2139095040, !dbg !1113
  %5799 = icmp eq i32 %5798, 2139095040, !dbg !1113
  %5800 = and i32 %5797, 8388607, !dbg !1113
  %5801 = icmp ne i32 %5800, 0, !dbg !1113
  %is_nan1383 = and i1 %5799, %5801, !dbg !1113
  %5802 = and i32 %5796, 4194304, !dbg !1113
  %5803 = icmp eq i32 %5802, 0, !dbg !1113
  %is_snan1384 = and i1 %is_nan1383, %5803, !dbg !1113
  %5804 = or i1 %is_snan1384, false, !dbg !1113
  %5805 = bitcast float %5793 to i32, !dbg !1113
  %5806 = and i32 %5805, 2147483647, !dbg !1113
  %is_zero1385 = icmp eq i32 %5806, 0, !dbg !1113
  %5807 = and i1 %is_zero1385, false, !dbg !1113
  %5808 = bitcast float %5793 to i32, !dbg !1113
  %5809 = and i32 %5808, 2139095040, !dbg !1113
  %5810 = icmp eq i32 %5809, 2139095040, !dbg !1113
  %5811 = and i32 %5808, 8388607, !dbg !1113
  %5812 = icmp eq i32 %5811, 0, !dbg !1113
  %is_inf1386 = and i1 %5810, %5812, !dbg !1113
  %5813 = and i1 %is_inf1386, false, !dbg !1113
  %5814 = or i1 %5807, %5813, !dbg !1113
  %5815 = or i1 %5804, %5814, !dbg !1113
  br i1 %5815, label %5816, label %5818, !dbg !1113

5816:                                             ; preds = %5795
  %5817 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %5818, !dbg !1113

5818:                                             ; preds = %5795, %5816
  %5819 = fmul float %5793, 0x4160000000000000, !dbg !1113
  %5820 = bitcast float %5793 to i32, !dbg !1113
  %5821 = and i32 %5820, 2139095040, !dbg !1113
  %is_finite1387 = icmp ne i32 %5821, 2139095040, !dbg !1113
  %5822 = and i1 true, %is_finite1387, !dbg !1113
  %5823 = and i1 %5822, true, !dbg !1113
  %5824 = bitcast float %5819 to i32, !dbg !1113
  %5825 = and i32 %5824, 2139095040, !dbg !1113
  %5826 = icmp eq i32 %5825, 2139095040, !dbg !1113
  %5827 = and i32 %5824, 8388607, !dbg !1113
  %5828 = icmp eq i32 %5827, 0, !dbg !1113
  %is_inf1388 = and i1 %5826, %5828, !dbg !1113
  %5829 = bitcast float %5819 to i32, !dbg !1113
  %5830 = and i32 %5829, 2147483647, !dbg !1113
  %is_maxfinite1389 = icmp eq i32 %5830, 2139095039, !dbg !1113
  %5831 = bitcast float %5819 to i32, !dbg !1113
  %5832 = and i32 %5831, -2147483648, !dbg !1113
  %5833 = icmp eq i32 %5832, 0, !dbg !1113
  %5834 = icmp ne i32 %5832, 0, !dbg !1113
  %is_pos_inf1390 = and i1 %is_inf1388, %5833, !dbg !1113
  %is_neg_inf1391 = and i1 %is_inf1388, %5834, !dbg !1113
  %is_pos_max1392 = and i1 %is_maxfinite1389, %5833, !dbg !1113
  %is_neg_max1393 = and i1 %is_maxfinite1389, %5834, !dbg !1113
  %overflow_cond1394 = and i1 %5823, %is_inf1388, !dbg !1113
  br i1 %overflow_cond1394, label %5835, label %5837, !dbg !1113

5835:                                             ; preds = %5818
  %5836 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %5837, !dbg !1113

5837:                                             ; preds = %5818, %5835
  %5838 = bitcast float %5793 to i32, !dbg !1113
  %5839 = and i32 %5838, 2139095040, !dbg !1113
  %5840 = icmp eq i32 %5839, 0, !dbg !1113
  %5841 = and i32 %5838, 8388607, !dbg !1113
  %5842 = icmp ne i32 %5841, 0, !dbg !1113
  %is_subnormal1395 = and i1 %5840, %5842, !dbg !1113
  %5843 = xor i1 %is_subnormal1395, true, !dbg !1113
  %5844 = and i1 true, %5843, !dbg !1113
  %5845 = and i1 %5844, true, !dbg !1113
  %5846 = bitcast float %5819 to i32, !dbg !1113
  %5847 = and i32 %5846, 2139095040, !dbg !1113
  %5848 = icmp eq i32 %5847, 0, !dbg !1113
  %5849 = and i32 %5846, 8388607, !dbg !1113
  %5850 = icmp ne i32 %5849, 0, !dbg !1113
  %is_subnormal1396 = and i1 %5848, %5850, !dbg !1113
  %5851 = bitcast float %5819 to i32, !dbg !1113
  %5852 = and i32 %5851, 2147483647, !dbg !1113
  %is_zero1397 = icmp eq i32 %5852, 0, !dbg !1113
  %5853 = bitcast float %5793 to i32, !dbg !1113
  %5854 = and i32 %5853, 2147483647, !dbg !1113
  %is_zero1398 = icmp eq i32 %5854, 0, !dbg !1113
  %5855 = xor i1 %is_zero1398, true, !dbg !1113
  %5856 = and i1 %5855, true, !dbg !1113
  %5857 = and i1 %is_zero1397, %5856, !dbg !1113
  %is_tiny1399 = or i1 %is_subnormal1396, %5857, !dbg !1113
  %underflow_cond1400 = and i1 %5845, %is_tiny1399, !dbg !1113
  br i1 %underflow_cond1400, label %5858, label %5860, !dbg !1113

5858:                                             ; preds = %5837
  %5859 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %5860, !dbg !1113

5860:                                             ; preds = %5837, %5858
  %5861 = bitcast float %5793 to i32, !dbg !1113
  %5862 = and i32 %5861, 2139095040, !dbg !1113
  %5863 = icmp eq i32 %5862, 0, !dbg !1113
  %5864 = and i32 %5861, 8388607, !dbg !1113
  %5865 = icmp ne i32 %5864, 0, !dbg !1113
  %is_subnormal1401 = and i1 %5863, %5865, !dbg !1113
  %5866 = xor i1 %is_subnormal1401, true, !dbg !1113
  %5867 = and i1 true, %5866, !dbg !1113
  %5868 = and i1 %5867, true, !dbg !1113
  %5869 = bitcast float %5819 to i32, !dbg !1113
  %5870 = and i32 %5869, 2139095040, !dbg !1113
  %5871 = icmp eq i32 %5870, 0, !dbg !1113
  %5872 = and i32 %5869, 8388607, !dbg !1113
  %5873 = icmp ne i32 %5872, 0, !dbg !1113
  %is_subnormal1402 = and i1 %5871, %5873, !dbg !1113
  %subnormal_cond1403 = and i1 %5868, %is_subnormal1402, !dbg !1113
  br i1 %subnormal_cond1403, label %5874, label %5876, !dbg !1113

5874:                                             ; preds = %5860
  %5875 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %5876, !dbg !1113

5876:                                             ; preds = %5860, %5874
  br label %5877, !dbg !1113

5877:                                             ; preds = %5876, %if.then56
  %.02.i = phi float [ %5819, %5876 ], [ %5793, %if.then56 ], !dbg !1113
  %i.i.0.i = phi float [ -2.300000e+01, %5876 ], [ 0.000000e+00, %if.then56 ], !dbg !1113
  %5878 = bitcast float %.02.i to i32, !dbg !1113
  %5879 = sub i32 %5878, 1059760811, !dbg !1113
  %5880 = and i32 %5879, -8388608, !dbg !1113
  %5881 = bitcast float %.02.i to i32, !dbg !1113
  %5882 = sub i32 %5881, %5880, !dbg !1113
  %5883 = bitcast i32 %5882 to float, !dbg !1113
  %5884 = sitofp i32 %5880 to float, !dbg !1113
  %5885 = bitcast float %5884 to i32, !dbg !1113
  %5886 = bitcast float %5884 to i32, !dbg !1113
  %5887 = and i32 %5886, 2139095040, !dbg !1113
  %5888 = icmp eq i32 %5887, 2139095040, !dbg !1113
  %5889 = and i32 %5886, 8388607, !dbg !1113
  %5890 = icmp ne i32 %5889, 0, !dbg !1113
  %is_nan1404 = and i1 %5888, %5890, !dbg !1113
  %5891 = and i32 %5885, 4194304, !dbg !1113
  %5892 = icmp eq i32 %5891, 0, !dbg !1113
  %is_snan1405 = and i1 %is_nan1404, %5892, !dbg !1113
  %5893 = or i1 %is_snan1405, false, !dbg !1113
  %5894 = bitcast float %i.i.0.i to i32, !dbg !1113
  %5895 = bitcast float %i.i.0.i to i32, !dbg !1113
  %5896 = and i32 %5895, 2139095040, !dbg !1113
  %5897 = icmp eq i32 %5896, 2139095040, !dbg !1113
  %5898 = and i32 %5895, 8388607, !dbg !1113
  %5899 = icmp ne i32 %5898, 0, !dbg !1113
  %is_nan1406 = and i1 %5897, %5899, !dbg !1113
  %5900 = and i32 %5894, 4194304, !dbg !1113
  %5901 = icmp eq i32 %5900, 0, !dbg !1113
  %is_snan1407 = and i1 %is_nan1406, %5901, !dbg !1113
  %5902 = or i1 %5893, %is_snan1407, !dbg !1113
  %5903 = bitcast float %5884 to i32, !dbg !1113
  %5904 = and i32 %5903, 2147483647, !dbg !1113
  %is_zero1408 = icmp eq i32 %5904, 0, !dbg !1113
  %5905 = and i1 %is_zero1408, false, !dbg !1113
  %5906 = bitcast float %5884 to i32, !dbg !1113
  %5907 = and i32 %5906, 2139095040, !dbg !1113
  %5908 = icmp eq i32 %5907, 2139095040, !dbg !1113
  %5909 = and i32 %5906, 8388607, !dbg !1113
  %5910 = icmp eq i32 %5909, 0, !dbg !1113
  %is_inf1409 = and i1 %5908, %5910, !dbg !1113
  %5911 = and i1 %is_inf1409, false, !dbg !1113
  %5912 = or i1 %5905, %5911, !dbg !1113
  %5913 = or i1 %5902, %5912, !dbg !1113
  br i1 %5913, label %5914, label %5916, !dbg !1113

5914:                                             ; preds = %5877
  %5915 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %5916, !dbg !1113

5916:                                             ; preds = %5877, %5914
  %5917 = call float @llvm.nvvm.fma.rn.f(float %5884, float 0x3E80000000000000, float %i.i.0.i) #5, !dbg !1113
  %5918 = bitcast float %5884 to i32, !dbg !1113
  %5919 = and i32 %5918, 2139095040, !dbg !1113
  %is_finite1410 = icmp ne i32 %5919, 2139095040, !dbg !1113
  %5920 = and i1 true, %is_finite1410, !dbg !1113
  %5921 = and i1 %5920, true, !dbg !1113
  %5922 = bitcast float %5917 to i32, !dbg !1113
  %5923 = and i32 %5922, 2139095040, !dbg !1113
  %5924 = icmp eq i32 %5923, 2139095040, !dbg !1113
  %5925 = and i32 %5922, 8388607, !dbg !1113
  %5926 = icmp eq i32 %5925, 0, !dbg !1113
  %is_inf1411 = and i1 %5924, %5926, !dbg !1113
  %5927 = bitcast float %5917 to i32, !dbg !1113
  %5928 = and i32 %5927, 2147483647, !dbg !1113
  %is_maxfinite1412 = icmp eq i32 %5928, 2139095039, !dbg !1113
  %5929 = bitcast float %5917 to i32, !dbg !1113
  %5930 = and i32 %5929, -2147483648, !dbg !1113
  %5931 = icmp eq i32 %5930, 0, !dbg !1113
  %5932 = icmp ne i32 %5930, 0, !dbg !1113
  %is_pos_inf1413 = and i1 %is_inf1411, %5931, !dbg !1113
  %is_neg_inf1414 = and i1 %is_inf1411, %5932, !dbg !1113
  %is_pos_max1415 = and i1 %is_maxfinite1412, %5931, !dbg !1113
  %is_neg_max1416 = and i1 %is_maxfinite1412, %5932, !dbg !1113
  %overflow_cond1417 = and i1 %5921, %is_inf1411, !dbg !1113
  br i1 %overflow_cond1417, label %5933, label %5935, !dbg !1113

5933:                                             ; preds = %5916
  %5934 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %5935, !dbg !1113

5935:                                             ; preds = %5916, %5933
  %5936 = bitcast float %5884 to i32, !dbg !1113
  %5937 = and i32 %5936, 2139095040, !dbg !1113
  %5938 = icmp eq i32 %5937, 0, !dbg !1113
  %5939 = and i32 %5936, 8388607, !dbg !1113
  %5940 = icmp ne i32 %5939, 0, !dbg !1113
  %is_subnormal1418 = and i1 %5938, %5940, !dbg !1113
  %5941 = xor i1 %is_subnormal1418, true, !dbg !1113
  %5942 = and i1 true, %5941, !dbg !1113
  %5943 = and i1 %5942, true, !dbg !1113
  %5944 = bitcast float %i.i.0.i to i32, !dbg !1113
  %5945 = and i32 %5944, 2139095040, !dbg !1113
  %5946 = icmp eq i32 %5945, 0, !dbg !1113
  %5947 = and i32 %5944, 8388607, !dbg !1113
  %5948 = icmp ne i32 %5947, 0, !dbg !1113
  %is_subnormal1419 = and i1 %5946, %5948, !dbg !1113
  %5949 = xor i1 %is_subnormal1419, true, !dbg !1113
  %5950 = and i1 %5943, %5949, !dbg !1113
  %5951 = bitcast float %5917 to i32, !dbg !1113
  %5952 = and i32 %5951, 2139095040, !dbg !1113
  %5953 = icmp eq i32 %5952, 0, !dbg !1113
  %5954 = and i32 %5951, 8388607, !dbg !1113
  %5955 = icmp ne i32 %5954, 0, !dbg !1113
  %is_subnormal1420 = and i1 %5953, %5955, !dbg !1113
  %5956 = bitcast float %5917 to i32, !dbg !1113
  %5957 = and i32 %5956, 2147483647, !dbg !1113
  %is_zero1421 = icmp eq i32 %5957, 0, !dbg !1113
  %5958 = bitcast float %5884 to i32, !dbg !1113
  %5959 = and i32 %5958, 2147483647, !dbg !1113
  %is_zero1422 = icmp eq i32 %5959, 0, !dbg !1113
  %5960 = xor i1 %is_zero1422, true, !dbg !1113
  %5961 = bitcast float %i.i.0.i to i32, !dbg !1113
  %5962 = and i32 %5961, 2147483647, !dbg !1113
  %is_zero1423 = icmp eq i32 %5962, 0, !dbg !1113
  %5963 = xor i1 %is_zero1423, true, !dbg !1113
  %5964 = and i1 %5960, true, !dbg !1113
  %5965 = and i1 %5964, %5963, !dbg !1113
  %5966 = and i1 %is_zero1421, %5965, !dbg !1113
  %is_tiny1424 = or i1 %is_subnormal1420, %5966, !dbg !1113
  %underflow_cond1425 = and i1 %5950, %is_tiny1424, !dbg !1113
  br i1 %underflow_cond1425, label %5967, label %5969, !dbg !1113

5967:                                             ; preds = %5935
  %5968 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %5969, !dbg !1113

5969:                                             ; preds = %5935, %5967
  %5970 = bitcast float %5884 to i32, !dbg !1113
  %5971 = and i32 %5970, 2139095040, !dbg !1113
  %5972 = icmp eq i32 %5971, 0, !dbg !1113
  %5973 = and i32 %5970, 8388607, !dbg !1113
  %5974 = icmp ne i32 %5973, 0, !dbg !1113
  %is_subnormal1426 = and i1 %5972, %5974, !dbg !1113
  %5975 = xor i1 %is_subnormal1426, true, !dbg !1113
  %5976 = and i1 true, %5975, !dbg !1113
  %5977 = and i1 %5976, true, !dbg !1113
  %5978 = bitcast float %i.i.0.i to i32, !dbg !1113
  %5979 = and i32 %5978, 2139095040, !dbg !1113
  %5980 = icmp eq i32 %5979, 0, !dbg !1113
  %5981 = and i32 %5978, 8388607, !dbg !1113
  %5982 = icmp ne i32 %5981, 0, !dbg !1113
  %is_subnormal1427 = and i1 %5980, %5982, !dbg !1113
  %5983 = xor i1 %is_subnormal1427, true, !dbg !1113
  %5984 = and i1 %5977, %5983, !dbg !1113
  %5985 = bitcast float %5917 to i32, !dbg !1113
  %5986 = and i32 %5985, 2139095040, !dbg !1113
  %5987 = icmp eq i32 %5986, 0, !dbg !1113
  %5988 = and i32 %5985, 8388607, !dbg !1113
  %5989 = icmp ne i32 %5988, 0, !dbg !1113
  %is_subnormal1428 = and i1 %5987, %5989, !dbg !1113
  %subnormal_cond1429 = and i1 %5984, %is_subnormal1428, !dbg !1113
  br i1 %subnormal_cond1429, label %5990, label %5992, !dbg !1113

5990:                                             ; preds = %5969
  %5991 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %5992, !dbg !1113

5992:                                             ; preds = %5969, %5990
  %5993 = bitcast float %5883 to i32, !dbg !1113
  %5994 = bitcast float %5883 to i32, !dbg !1113
  %5995 = and i32 %5994, 2139095040, !dbg !1113
  %5996 = icmp eq i32 %5995, 2139095040, !dbg !1113
  %5997 = and i32 %5994, 8388607, !dbg !1113
  %5998 = icmp ne i32 %5997, 0, !dbg !1113
  %is_nan1430 = and i1 %5996, %5998, !dbg !1113
  %5999 = and i32 %5993, 4194304, !dbg !1113
  %6000 = icmp eq i32 %5999, 0, !dbg !1113
  %is_snan1431 = and i1 %is_nan1430, %6000, !dbg !1113
  %6001 = or i1 %is_snan1431, false, !dbg !1113
  %6002 = bitcast float %5883 to i32, !dbg !1113
  %6003 = and i32 %6002, 2139095040, !dbg !1113
  %6004 = icmp eq i32 %6003, 2139095040, !dbg !1113
  %6005 = and i32 %6002, 8388607, !dbg !1113
  %6006 = icmp eq i32 %6005, 0, !dbg !1113
  %is_inf1432 = and i1 %6004, %6006, !dbg !1113
  %6007 = and i1 %is_inf1432, false, !dbg !1113
  %6008 = bitcast float %5883 to i32, !dbg !1113
  %6009 = and i32 %6008, -2147483648, !dbg !1113
  %6010 = icmp eq i32 %6009, 0, !dbg !1113
  %6011 = and i1 %6007, %6010, !dbg !1113
  %6012 = or i1 %6001, %6011, !dbg !1113
  br i1 %6012, label %6013, label %6015, !dbg !1113

6013:                                             ; preds = %5992
  %6014 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6015, !dbg !1113

6015:                                             ; preds = %5992, %6013
  %6016 = fsub float %5883, 1.000000e+00, !dbg !1113
  %6017 = bitcast float %5883 to i32, !dbg !1113
  %6018 = and i32 %6017, 2139095040, !dbg !1113
  %is_finite1433 = icmp ne i32 %6018, 2139095040, !dbg !1113
  %6019 = and i1 true, %is_finite1433, !dbg !1113
  %6020 = and i1 %6019, true, !dbg !1113
  %6021 = bitcast float %6016 to i32, !dbg !1113
  %6022 = and i32 %6021, 2139095040, !dbg !1113
  %6023 = icmp eq i32 %6022, 2139095040, !dbg !1113
  %6024 = and i32 %6021, 8388607, !dbg !1113
  %6025 = icmp eq i32 %6024, 0, !dbg !1113
  %is_inf1434 = and i1 %6023, %6025, !dbg !1113
  %6026 = bitcast float %6016 to i32, !dbg !1113
  %6027 = and i32 %6026, 2147483647, !dbg !1113
  %is_maxfinite1435 = icmp eq i32 %6027, 2139095039, !dbg !1113
  %6028 = bitcast float %6016 to i32, !dbg !1113
  %6029 = and i32 %6028, -2147483648, !dbg !1113
  %6030 = icmp eq i32 %6029, 0, !dbg !1113
  %6031 = icmp ne i32 %6029, 0, !dbg !1113
  %is_pos_inf1436 = and i1 %is_inf1434, %6030, !dbg !1113
  %is_neg_inf1437 = and i1 %is_inf1434, %6031, !dbg !1113
  %is_pos_max1438 = and i1 %is_maxfinite1435, %6030, !dbg !1113
  %is_neg_max1439 = and i1 %is_maxfinite1435, %6031, !dbg !1113
  %overflow_cond1440 = and i1 %6020, %is_inf1434, !dbg !1113
  br i1 %overflow_cond1440, label %6032, label %6034, !dbg !1113

6032:                                             ; preds = %6015
  %6033 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6034, !dbg !1113

6034:                                             ; preds = %6015, %6032
  %6035 = bitcast float %5883 to i32, !dbg !1113
  %6036 = and i32 %6035, 2139095040, !dbg !1113
  %6037 = icmp eq i32 %6036, 0, !dbg !1113
  %6038 = and i32 %6035, 8388607, !dbg !1113
  %6039 = icmp ne i32 %6038, 0, !dbg !1113
  %is_subnormal1441 = and i1 %6037, %6039, !dbg !1113
  %6040 = xor i1 %is_subnormal1441, true, !dbg !1113
  %6041 = and i1 true, %6040, !dbg !1113
  %6042 = and i1 %6041, true, !dbg !1113
  %6043 = bitcast float %6016 to i32, !dbg !1113
  %6044 = and i32 %6043, 2139095040, !dbg !1113
  %6045 = icmp eq i32 %6044, 0, !dbg !1113
  %6046 = and i32 %6043, 8388607, !dbg !1113
  %6047 = icmp ne i32 %6046, 0, !dbg !1113
  %is_subnormal1442 = and i1 %6045, %6047, !dbg !1113
  %subnormal_cond1443 = and i1 %6042, %is_subnormal1442, !dbg !1113
  br i1 %subnormal_cond1443, label %6048, label %6050, !dbg !1113

6048:                                             ; preds = %6034
  %6049 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6050, !dbg !1113

6050:                                             ; preds = %6034, %6048
  %6051 = bitcast float %6016 to i32, !dbg !1113
  %6052 = bitcast float %6016 to i32, !dbg !1113
  %6053 = and i32 %6052, 2139095040, !dbg !1113
  %6054 = icmp eq i32 %6053, 2139095040, !dbg !1113
  %6055 = and i32 %6052, 8388607, !dbg !1113
  %6056 = icmp ne i32 %6055, 0, !dbg !1113
  %is_nan1444 = and i1 %6054, %6056, !dbg !1113
  %6057 = and i32 %6051, 4194304, !dbg !1113
  %6058 = icmp eq i32 %6057, 0, !dbg !1113
  %is_snan1445 = and i1 %is_nan1444, %6058, !dbg !1113
  %6059 = or i1 false, %is_snan1445, !dbg !1113
  %6060 = or i1 %6059, false, !dbg !1113
  %6061 = bitcast float %6016 to i32, !dbg !1113
  %6062 = and i32 %6061, 2139095040, !dbg !1113
  %6063 = icmp eq i32 %6062, 2139095040, !dbg !1113
  %6064 = and i32 %6061, 8388607, !dbg !1113
  %6065 = icmp eq i32 %6064, 0, !dbg !1113
  %is_inf1446 = and i1 %6063, %6065, !dbg !1113
  %6066 = and i1 false, %is_inf1446, !dbg !1113
  %6067 = bitcast float %6016 to i32, !dbg !1113
  %6068 = and i32 %6067, 2147483647, !dbg !1113
  %is_zero1447 = icmp eq i32 %6068, 0, !dbg !1113
  %6069 = and i1 false, %is_zero1447, !dbg !1113
  %6070 = or i1 %6066, %6069, !dbg !1113
  %6071 = or i1 %6060, %6070, !dbg !1113
  br i1 %6071, label %6072, label %6074, !dbg !1113

6072:                                             ; preds = %6050
  %6073 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6074, !dbg !1113

6074:                                             ; preds = %6050, %6072
  %6075 = call float @llvm.nvvm.fma.rn.f(float 0xBFC0AA04E0000000, float %6016, float 0x3FC2073EC0000000) #5, !dbg !1113
  %6076 = bitcast float %6016 to i32, !dbg !1113
  %6077 = and i32 %6076, 2139095040, !dbg !1113
  %is_finite1448 = icmp ne i32 %6077, 2139095040, !dbg !1113
  %6078 = and i1 true, %is_finite1448, !dbg !1113
  %6079 = bitcast float %6075 to i32, !dbg !1113
  %6080 = and i32 %6079, 2139095040, !dbg !1113
  %6081 = icmp eq i32 %6080, 2139095040, !dbg !1113
  %6082 = and i32 %6079, 8388607, !dbg !1113
  %6083 = icmp eq i32 %6082, 0, !dbg !1113
  %is_inf1449 = and i1 %6081, %6083, !dbg !1113
  %6084 = bitcast float %6075 to i32, !dbg !1113
  %6085 = and i32 %6084, 2147483647, !dbg !1113
  %is_maxfinite1450 = icmp eq i32 %6085, 2139095039, !dbg !1113
  %6086 = bitcast float %6075 to i32, !dbg !1113
  %6087 = and i32 %6086, -2147483648, !dbg !1113
  %6088 = icmp eq i32 %6087, 0, !dbg !1113
  %6089 = icmp ne i32 %6087, 0, !dbg !1113
  %is_pos_inf1451 = and i1 %is_inf1449, %6088, !dbg !1113
  %is_neg_inf1452 = and i1 %is_inf1449, %6089, !dbg !1113
  %is_pos_max1453 = and i1 %is_maxfinite1450, %6088, !dbg !1113
  %is_neg_max1454 = and i1 %is_maxfinite1450, %6089, !dbg !1113
  %overflow_cond1455 = and i1 %6078, %is_inf1449, !dbg !1113
  br i1 %overflow_cond1455, label %6090, label %6092, !dbg !1113

6090:                                             ; preds = %6074
  %6091 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6092, !dbg !1113

6092:                                             ; preds = %6074, %6090
  %6093 = bitcast float %6016 to i32, !dbg !1113
  %6094 = and i32 %6093, 2139095040, !dbg !1113
  %6095 = icmp eq i32 %6094, 0, !dbg !1113
  %6096 = and i32 %6093, 8388607, !dbg !1113
  %6097 = icmp ne i32 %6096, 0, !dbg !1113
  %is_subnormal1456 = and i1 %6095, %6097, !dbg !1113
  %6098 = xor i1 %is_subnormal1456, true, !dbg !1113
  %6099 = and i1 true, %6098, !dbg !1113
  %6100 = and i1 %6099, true, !dbg !1113
  %6101 = bitcast float %6075 to i32, !dbg !1113
  %6102 = and i32 %6101, 2139095040, !dbg !1113
  %6103 = icmp eq i32 %6102, 0, !dbg !1113
  %6104 = and i32 %6101, 8388607, !dbg !1113
  %6105 = icmp ne i32 %6104, 0, !dbg !1113
  %is_subnormal1457 = and i1 %6103, %6105, !dbg !1113
  %6106 = bitcast float %6075 to i32, !dbg !1113
  %6107 = and i32 %6106, 2147483647, !dbg !1113
  %is_zero1458 = icmp eq i32 %6107, 0, !dbg !1113
  %6108 = bitcast float %6016 to i32, !dbg !1113
  %6109 = and i32 %6108, 2147483647, !dbg !1113
  %is_zero1459 = icmp eq i32 %6109, 0, !dbg !1113
  %6110 = xor i1 %is_zero1459, true, !dbg !1113
  %6111 = and i1 true, %6110, !dbg !1113
  %6112 = and i1 %6111, true, !dbg !1113
  %6113 = and i1 %is_zero1458, %6112, !dbg !1113
  %is_tiny1460 = or i1 %is_subnormal1457, %6113, !dbg !1113
  %underflow_cond1461 = and i1 %6100, %is_tiny1460, !dbg !1113
  br i1 %underflow_cond1461, label %6114, label %6116, !dbg !1113

6114:                                             ; preds = %6092
  %6115 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6116, !dbg !1113

6116:                                             ; preds = %6092, %6114
  %6117 = bitcast float %6016 to i32, !dbg !1113
  %6118 = and i32 %6117, 2139095040, !dbg !1113
  %6119 = icmp eq i32 %6118, 0, !dbg !1113
  %6120 = and i32 %6117, 8388607, !dbg !1113
  %6121 = icmp ne i32 %6120, 0, !dbg !1113
  %is_subnormal1462 = and i1 %6119, %6121, !dbg !1113
  %6122 = xor i1 %is_subnormal1462, true, !dbg !1113
  %6123 = and i1 true, %6122, !dbg !1113
  %6124 = and i1 %6123, true, !dbg !1113
  %6125 = bitcast float %6075 to i32, !dbg !1113
  %6126 = and i32 %6125, 2139095040, !dbg !1113
  %6127 = icmp eq i32 %6126, 0, !dbg !1113
  %6128 = and i32 %6125, 8388607, !dbg !1113
  %6129 = icmp ne i32 %6128, 0, !dbg !1113
  %is_subnormal1463 = and i1 %6127, %6129, !dbg !1113
  %subnormal_cond1464 = and i1 %6124, %is_subnormal1463, !dbg !1113
  br i1 %subnormal_cond1464, label %6130, label %6132, !dbg !1113

6130:                                             ; preds = %6116
  %6131 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6132, !dbg !1113

6132:                                             ; preds = %6116, %6130
  %6133 = bitcast float %6075 to i32, !dbg !1113
  %6134 = bitcast float %6075 to i32, !dbg !1113
  %6135 = and i32 %6134, 2139095040, !dbg !1113
  %6136 = icmp eq i32 %6135, 2139095040, !dbg !1113
  %6137 = and i32 %6134, 8388607, !dbg !1113
  %6138 = icmp ne i32 %6137, 0, !dbg !1113
  %is_nan1465 = and i1 %6136, %6138, !dbg !1113
  %6139 = and i32 %6133, 4194304, !dbg !1113
  %6140 = icmp eq i32 %6139, 0, !dbg !1113
  %is_snan1466 = and i1 %is_nan1465, %6140, !dbg !1113
  %6141 = bitcast float %6016 to i32, !dbg !1113
  %6142 = bitcast float %6016 to i32, !dbg !1113
  %6143 = and i32 %6142, 2139095040, !dbg !1113
  %6144 = icmp eq i32 %6143, 2139095040, !dbg !1113
  %6145 = and i32 %6142, 8388607, !dbg !1113
  %6146 = icmp ne i32 %6145, 0, !dbg !1113
  %is_nan1467 = and i1 %6144, %6146, !dbg !1113
  %6147 = and i32 %6141, 4194304, !dbg !1113
  %6148 = icmp eq i32 %6147, 0, !dbg !1113
  %is_snan1468 = and i1 %is_nan1467, %6148, !dbg !1113
  %6149 = or i1 %is_snan1466, %is_snan1468, !dbg !1113
  %6150 = or i1 %6149, false, !dbg !1113
  %6151 = bitcast float %6075 to i32, !dbg !1113
  %6152 = and i32 %6151, 2147483647, !dbg !1113
  %is_zero1469 = icmp eq i32 %6152, 0, !dbg !1113
  %6153 = bitcast float %6016 to i32, !dbg !1113
  %6154 = and i32 %6153, 2139095040, !dbg !1113
  %6155 = icmp eq i32 %6154, 2139095040, !dbg !1113
  %6156 = and i32 %6153, 8388607, !dbg !1113
  %6157 = icmp eq i32 %6156, 0, !dbg !1113
  %is_inf1470 = and i1 %6155, %6157, !dbg !1113
  %6158 = and i1 %is_zero1469, %is_inf1470, !dbg !1113
  %6159 = bitcast float %6075 to i32, !dbg !1113
  %6160 = and i32 %6159, 2139095040, !dbg !1113
  %6161 = icmp eq i32 %6160, 2139095040, !dbg !1113
  %6162 = and i32 %6159, 8388607, !dbg !1113
  %6163 = icmp eq i32 %6162, 0, !dbg !1113
  %is_inf1471 = and i1 %6161, %6163, !dbg !1113
  %6164 = bitcast float %6016 to i32, !dbg !1113
  %6165 = and i32 %6164, 2147483647, !dbg !1113
  %is_zero1472 = icmp eq i32 %6165, 0, !dbg !1113
  %6166 = and i1 %is_inf1471, %is_zero1472, !dbg !1113
  %6167 = or i1 %6158, %6166, !dbg !1113
  %6168 = or i1 %6150, %6167, !dbg !1113
  br i1 %6168, label %6169, label %6171, !dbg !1113

6169:                                             ; preds = %6132
  %6170 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6171, !dbg !1113

6171:                                             ; preds = %6132, %6169
  %6172 = call float @llvm.nvvm.fma.rn.f(float %6075, float %6016, float 0xBFBF19B980000000) #5, !dbg !1113
  %6173 = bitcast float %6075 to i32, !dbg !1113
  %6174 = and i32 %6173, 2139095040, !dbg !1113
  %is_finite1473 = icmp ne i32 %6174, 2139095040, !dbg !1113
  %6175 = and i1 true, %is_finite1473, !dbg !1113
  %6176 = bitcast float %6016 to i32, !dbg !1113
  %6177 = and i32 %6176, 2139095040, !dbg !1113
  %is_finite1474 = icmp ne i32 %6177, 2139095040, !dbg !1113
  %6178 = and i1 %6175, %is_finite1474, !dbg !1113
  %6179 = bitcast float %6172 to i32, !dbg !1113
  %6180 = and i32 %6179, 2139095040, !dbg !1113
  %6181 = icmp eq i32 %6180, 2139095040, !dbg !1113
  %6182 = and i32 %6179, 8388607, !dbg !1113
  %6183 = icmp eq i32 %6182, 0, !dbg !1113
  %is_inf1475 = and i1 %6181, %6183, !dbg !1113
  %6184 = bitcast float %6172 to i32, !dbg !1113
  %6185 = and i32 %6184, 2147483647, !dbg !1113
  %is_maxfinite1476 = icmp eq i32 %6185, 2139095039, !dbg !1113
  %6186 = bitcast float %6172 to i32, !dbg !1113
  %6187 = and i32 %6186, -2147483648, !dbg !1113
  %6188 = icmp eq i32 %6187, 0, !dbg !1113
  %6189 = icmp ne i32 %6187, 0, !dbg !1113
  %is_pos_inf1477 = and i1 %is_inf1475, %6188, !dbg !1113
  %is_neg_inf1478 = and i1 %is_inf1475, %6189, !dbg !1113
  %is_pos_max1479 = and i1 %is_maxfinite1476, %6188, !dbg !1113
  %is_neg_max1480 = and i1 %is_maxfinite1476, %6189, !dbg !1113
  %overflow_cond1481 = and i1 %6178, %is_inf1475, !dbg !1113
  br i1 %overflow_cond1481, label %6190, label %6192, !dbg !1113

6190:                                             ; preds = %6171
  %6191 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6192, !dbg !1113

6192:                                             ; preds = %6171, %6190
  %6193 = bitcast float %6075 to i32, !dbg !1113
  %6194 = and i32 %6193, 2139095040, !dbg !1113
  %6195 = icmp eq i32 %6194, 0, !dbg !1113
  %6196 = and i32 %6193, 8388607, !dbg !1113
  %6197 = icmp ne i32 %6196, 0, !dbg !1113
  %is_subnormal1482 = and i1 %6195, %6197, !dbg !1113
  %6198 = xor i1 %is_subnormal1482, true, !dbg !1113
  %6199 = and i1 true, %6198, !dbg !1113
  %6200 = bitcast float %6016 to i32, !dbg !1113
  %6201 = and i32 %6200, 2139095040, !dbg !1113
  %6202 = icmp eq i32 %6201, 0, !dbg !1113
  %6203 = and i32 %6200, 8388607, !dbg !1113
  %6204 = icmp ne i32 %6203, 0, !dbg !1113
  %is_subnormal1483 = and i1 %6202, %6204, !dbg !1113
  %6205 = xor i1 %is_subnormal1483, true, !dbg !1113
  %6206 = and i1 %6199, %6205, !dbg !1113
  %6207 = and i1 %6206, true, !dbg !1113
  %6208 = bitcast float %6172 to i32, !dbg !1113
  %6209 = and i32 %6208, 2139095040, !dbg !1113
  %6210 = icmp eq i32 %6209, 0, !dbg !1113
  %6211 = and i32 %6208, 8388607, !dbg !1113
  %6212 = icmp ne i32 %6211, 0, !dbg !1113
  %is_subnormal1484 = and i1 %6210, %6212, !dbg !1113
  %6213 = bitcast float %6172 to i32, !dbg !1113
  %6214 = and i32 %6213, 2147483647, !dbg !1113
  %is_zero1485 = icmp eq i32 %6214, 0, !dbg !1113
  %6215 = bitcast float %6075 to i32, !dbg !1113
  %6216 = and i32 %6215, 2147483647, !dbg !1113
  %is_zero1486 = icmp eq i32 %6216, 0, !dbg !1113
  %6217 = xor i1 %is_zero1486, true, !dbg !1113
  %6218 = bitcast float %6016 to i32, !dbg !1113
  %6219 = and i32 %6218, 2147483647, !dbg !1113
  %is_zero1487 = icmp eq i32 %6219, 0, !dbg !1113
  %6220 = xor i1 %is_zero1487, true, !dbg !1113
  %6221 = and i1 %6217, %6220, !dbg !1113
  %6222 = and i1 %6221, true, !dbg !1113
  %6223 = and i1 %is_zero1485, %6222, !dbg !1113
  %is_tiny1488 = or i1 %is_subnormal1484, %6223, !dbg !1113
  %underflow_cond1489 = and i1 %6207, %is_tiny1488, !dbg !1113
  br i1 %underflow_cond1489, label %6224, label %6226, !dbg !1113

6224:                                             ; preds = %6192
  %6225 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6226, !dbg !1113

6226:                                             ; preds = %6192, %6224
  %6227 = bitcast float %6075 to i32, !dbg !1113
  %6228 = and i32 %6227, 2139095040, !dbg !1113
  %6229 = icmp eq i32 %6228, 0, !dbg !1113
  %6230 = and i32 %6227, 8388607, !dbg !1113
  %6231 = icmp ne i32 %6230, 0, !dbg !1113
  %is_subnormal1490 = and i1 %6229, %6231, !dbg !1113
  %6232 = xor i1 %is_subnormal1490, true, !dbg !1113
  %6233 = and i1 true, %6232, !dbg !1113
  %6234 = bitcast float %6016 to i32, !dbg !1113
  %6235 = and i32 %6234, 2139095040, !dbg !1113
  %6236 = icmp eq i32 %6235, 0, !dbg !1113
  %6237 = and i32 %6234, 8388607, !dbg !1113
  %6238 = icmp ne i32 %6237, 0, !dbg !1113
  %is_subnormal1491 = and i1 %6236, %6238, !dbg !1113
  %6239 = xor i1 %is_subnormal1491, true, !dbg !1113
  %6240 = and i1 %6233, %6239, !dbg !1113
  %6241 = and i1 %6240, true, !dbg !1113
  %6242 = bitcast float %6172 to i32, !dbg !1113
  %6243 = and i32 %6242, 2139095040, !dbg !1113
  %6244 = icmp eq i32 %6243, 0, !dbg !1113
  %6245 = and i32 %6242, 8388607, !dbg !1113
  %6246 = icmp ne i32 %6245, 0, !dbg !1113
  %is_subnormal1492 = and i1 %6244, %6246, !dbg !1113
  %subnormal_cond1493 = and i1 %6241, %is_subnormal1492, !dbg !1113
  br i1 %subnormal_cond1493, label %6247, label %6249, !dbg !1113

6247:                                             ; preds = %6226
  %6248 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6249, !dbg !1113

6249:                                             ; preds = %6226, %6247
  %6250 = bitcast float %6172 to i32, !dbg !1113
  %6251 = bitcast float %6172 to i32, !dbg !1113
  %6252 = and i32 %6251, 2139095040, !dbg !1113
  %6253 = icmp eq i32 %6252, 2139095040, !dbg !1113
  %6254 = and i32 %6251, 8388607, !dbg !1113
  %6255 = icmp ne i32 %6254, 0, !dbg !1113
  %is_nan1494 = and i1 %6253, %6255, !dbg !1113
  %6256 = and i32 %6250, 4194304, !dbg !1113
  %6257 = icmp eq i32 %6256, 0, !dbg !1113
  %is_snan1495 = and i1 %is_nan1494, %6257, !dbg !1113
  %6258 = bitcast float %6016 to i32, !dbg !1113
  %6259 = bitcast float %6016 to i32, !dbg !1113
  %6260 = and i32 %6259, 2139095040, !dbg !1113
  %6261 = icmp eq i32 %6260, 2139095040, !dbg !1113
  %6262 = and i32 %6259, 8388607, !dbg !1113
  %6263 = icmp ne i32 %6262, 0, !dbg !1113
  %is_nan1496 = and i1 %6261, %6263, !dbg !1113
  %6264 = and i32 %6258, 4194304, !dbg !1113
  %6265 = icmp eq i32 %6264, 0, !dbg !1113
  %is_snan1497 = and i1 %is_nan1496, %6265, !dbg !1113
  %6266 = or i1 %is_snan1495, %is_snan1497, !dbg !1113
  %6267 = or i1 %6266, false, !dbg !1113
  %6268 = bitcast float %6172 to i32, !dbg !1113
  %6269 = and i32 %6268, 2147483647, !dbg !1113
  %is_zero1498 = icmp eq i32 %6269, 0, !dbg !1113
  %6270 = bitcast float %6016 to i32, !dbg !1113
  %6271 = and i32 %6270, 2139095040, !dbg !1113
  %6272 = icmp eq i32 %6271, 2139095040, !dbg !1113
  %6273 = and i32 %6270, 8388607, !dbg !1113
  %6274 = icmp eq i32 %6273, 0, !dbg !1113
  %is_inf1499 = and i1 %6272, %6274, !dbg !1113
  %6275 = and i1 %is_zero1498, %is_inf1499, !dbg !1113
  %6276 = bitcast float %6172 to i32, !dbg !1113
  %6277 = and i32 %6276, 2139095040, !dbg !1113
  %6278 = icmp eq i32 %6277, 2139095040, !dbg !1113
  %6279 = and i32 %6276, 8388607, !dbg !1113
  %6280 = icmp eq i32 %6279, 0, !dbg !1113
  %is_inf1500 = and i1 %6278, %6280, !dbg !1113
  %6281 = bitcast float %6016 to i32, !dbg !1113
  %6282 = and i32 %6281, 2147483647, !dbg !1113
  %is_zero1501 = icmp eq i32 %6282, 0, !dbg !1113
  %6283 = and i1 %is_inf1500, %is_zero1501, !dbg !1113
  %6284 = or i1 %6275, %6283, !dbg !1113
  %6285 = or i1 %6267, %6284, !dbg !1113
  br i1 %6285, label %6286, label %6288, !dbg !1113

6286:                                             ; preds = %6249
  %6287 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6288, !dbg !1113

6288:                                             ; preds = %6249, %6286
  %6289 = call float @llvm.nvvm.fma.rn.f(float %6172, float %6016, float 0x3FC1E52AA0000000) #5, !dbg !1113
  %6290 = bitcast float %6172 to i32, !dbg !1113
  %6291 = and i32 %6290, 2139095040, !dbg !1113
  %is_finite1502 = icmp ne i32 %6291, 2139095040, !dbg !1113
  %6292 = and i1 true, %is_finite1502, !dbg !1113
  %6293 = bitcast float %6016 to i32, !dbg !1113
  %6294 = and i32 %6293, 2139095040, !dbg !1113
  %is_finite1503 = icmp ne i32 %6294, 2139095040, !dbg !1113
  %6295 = and i1 %6292, %is_finite1503, !dbg !1113
  %6296 = bitcast float %6289 to i32, !dbg !1113
  %6297 = and i32 %6296, 2139095040, !dbg !1113
  %6298 = icmp eq i32 %6297, 2139095040, !dbg !1113
  %6299 = and i32 %6296, 8388607, !dbg !1113
  %6300 = icmp eq i32 %6299, 0, !dbg !1113
  %is_inf1504 = and i1 %6298, %6300, !dbg !1113
  %6301 = bitcast float %6289 to i32, !dbg !1113
  %6302 = and i32 %6301, 2147483647, !dbg !1113
  %is_maxfinite1505 = icmp eq i32 %6302, 2139095039, !dbg !1113
  %6303 = bitcast float %6289 to i32, !dbg !1113
  %6304 = and i32 %6303, -2147483648, !dbg !1113
  %6305 = icmp eq i32 %6304, 0, !dbg !1113
  %6306 = icmp ne i32 %6304, 0, !dbg !1113
  %is_pos_inf1506 = and i1 %is_inf1504, %6305, !dbg !1113
  %is_neg_inf1507 = and i1 %is_inf1504, %6306, !dbg !1113
  %is_pos_max1508 = and i1 %is_maxfinite1505, %6305, !dbg !1113
  %is_neg_max1509 = and i1 %is_maxfinite1505, %6306, !dbg !1113
  %overflow_cond1510 = and i1 %6295, %is_inf1504, !dbg !1113
  br i1 %overflow_cond1510, label %6307, label %6309, !dbg !1113

6307:                                             ; preds = %6288
  %6308 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6309, !dbg !1113

6309:                                             ; preds = %6288, %6307
  %6310 = bitcast float %6172 to i32, !dbg !1113
  %6311 = and i32 %6310, 2139095040, !dbg !1113
  %6312 = icmp eq i32 %6311, 0, !dbg !1113
  %6313 = and i32 %6310, 8388607, !dbg !1113
  %6314 = icmp ne i32 %6313, 0, !dbg !1113
  %is_subnormal1511 = and i1 %6312, %6314, !dbg !1113
  %6315 = xor i1 %is_subnormal1511, true, !dbg !1113
  %6316 = and i1 true, %6315, !dbg !1113
  %6317 = bitcast float %6016 to i32, !dbg !1113
  %6318 = and i32 %6317, 2139095040, !dbg !1113
  %6319 = icmp eq i32 %6318, 0, !dbg !1113
  %6320 = and i32 %6317, 8388607, !dbg !1113
  %6321 = icmp ne i32 %6320, 0, !dbg !1113
  %is_subnormal1512 = and i1 %6319, %6321, !dbg !1113
  %6322 = xor i1 %is_subnormal1512, true, !dbg !1113
  %6323 = and i1 %6316, %6322, !dbg !1113
  %6324 = and i1 %6323, true, !dbg !1113
  %6325 = bitcast float %6289 to i32, !dbg !1113
  %6326 = and i32 %6325, 2139095040, !dbg !1113
  %6327 = icmp eq i32 %6326, 0, !dbg !1113
  %6328 = and i32 %6325, 8388607, !dbg !1113
  %6329 = icmp ne i32 %6328, 0, !dbg !1113
  %is_subnormal1513 = and i1 %6327, %6329, !dbg !1113
  %6330 = bitcast float %6289 to i32, !dbg !1113
  %6331 = and i32 %6330, 2147483647, !dbg !1113
  %is_zero1514 = icmp eq i32 %6331, 0, !dbg !1113
  %6332 = bitcast float %6172 to i32, !dbg !1113
  %6333 = and i32 %6332, 2147483647, !dbg !1113
  %is_zero1515 = icmp eq i32 %6333, 0, !dbg !1113
  %6334 = xor i1 %is_zero1515, true, !dbg !1113
  %6335 = bitcast float %6016 to i32, !dbg !1113
  %6336 = and i32 %6335, 2147483647, !dbg !1113
  %is_zero1516 = icmp eq i32 %6336, 0, !dbg !1113
  %6337 = xor i1 %is_zero1516, true, !dbg !1113
  %6338 = and i1 %6334, %6337, !dbg !1113
  %6339 = and i1 %6338, true, !dbg !1113
  %6340 = and i1 %is_zero1514, %6339, !dbg !1113
  %is_tiny1517 = or i1 %is_subnormal1513, %6340, !dbg !1113
  %underflow_cond1518 = and i1 %6324, %is_tiny1517, !dbg !1113
  br i1 %underflow_cond1518, label %6341, label %6343, !dbg !1113

6341:                                             ; preds = %6309
  %6342 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6343, !dbg !1113

6343:                                             ; preds = %6309, %6341
  %6344 = bitcast float %6172 to i32, !dbg !1113
  %6345 = and i32 %6344, 2139095040, !dbg !1113
  %6346 = icmp eq i32 %6345, 0, !dbg !1113
  %6347 = and i32 %6344, 8388607, !dbg !1113
  %6348 = icmp ne i32 %6347, 0, !dbg !1113
  %is_subnormal1519 = and i1 %6346, %6348, !dbg !1113
  %6349 = xor i1 %is_subnormal1519, true, !dbg !1113
  %6350 = and i1 true, %6349, !dbg !1113
  %6351 = bitcast float %6016 to i32, !dbg !1113
  %6352 = and i32 %6351, 2139095040, !dbg !1113
  %6353 = icmp eq i32 %6352, 0, !dbg !1113
  %6354 = and i32 %6351, 8388607, !dbg !1113
  %6355 = icmp ne i32 %6354, 0, !dbg !1113
  %is_subnormal1520 = and i1 %6353, %6355, !dbg !1113
  %6356 = xor i1 %is_subnormal1520, true, !dbg !1113
  %6357 = and i1 %6350, %6356, !dbg !1113
  %6358 = and i1 %6357, true, !dbg !1113
  %6359 = bitcast float %6289 to i32, !dbg !1113
  %6360 = and i32 %6359, 2139095040, !dbg !1113
  %6361 = icmp eq i32 %6360, 0, !dbg !1113
  %6362 = and i32 %6359, 8388607, !dbg !1113
  %6363 = icmp ne i32 %6362, 0, !dbg !1113
  %is_subnormal1521 = and i1 %6361, %6363, !dbg !1113
  %subnormal_cond1522 = and i1 %6358, %is_subnormal1521, !dbg !1113
  br i1 %subnormal_cond1522, label %6364, label %6366, !dbg !1113

6364:                                             ; preds = %6343
  %6365 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6366, !dbg !1113

6366:                                             ; preds = %6343, %6364
  %6367 = bitcast float %6289 to i32, !dbg !1113
  %6368 = bitcast float %6289 to i32, !dbg !1113
  %6369 = and i32 %6368, 2139095040, !dbg !1113
  %6370 = icmp eq i32 %6369, 2139095040, !dbg !1113
  %6371 = and i32 %6368, 8388607, !dbg !1113
  %6372 = icmp ne i32 %6371, 0, !dbg !1113
  %is_nan1523 = and i1 %6370, %6372, !dbg !1113
  %6373 = and i32 %6367, 4194304, !dbg !1113
  %6374 = icmp eq i32 %6373, 0, !dbg !1113
  %is_snan1524 = and i1 %is_nan1523, %6374, !dbg !1113
  %6375 = bitcast float %6016 to i32, !dbg !1113
  %6376 = bitcast float %6016 to i32, !dbg !1113
  %6377 = and i32 %6376, 2139095040, !dbg !1113
  %6378 = icmp eq i32 %6377, 2139095040, !dbg !1113
  %6379 = and i32 %6376, 8388607, !dbg !1113
  %6380 = icmp ne i32 %6379, 0, !dbg !1113
  %is_nan1525 = and i1 %6378, %6380, !dbg !1113
  %6381 = and i32 %6375, 4194304, !dbg !1113
  %6382 = icmp eq i32 %6381, 0, !dbg !1113
  %is_snan1526 = and i1 %is_nan1525, %6382, !dbg !1113
  %6383 = or i1 %is_snan1524, %is_snan1526, !dbg !1113
  %6384 = or i1 %6383, false, !dbg !1113
  %6385 = bitcast float %6289 to i32, !dbg !1113
  %6386 = and i32 %6385, 2147483647, !dbg !1113
  %is_zero1527 = icmp eq i32 %6386, 0, !dbg !1113
  %6387 = bitcast float %6016 to i32, !dbg !1113
  %6388 = and i32 %6387, 2139095040, !dbg !1113
  %6389 = icmp eq i32 %6388, 2139095040, !dbg !1113
  %6390 = and i32 %6387, 8388607, !dbg !1113
  %6391 = icmp eq i32 %6390, 0, !dbg !1113
  %is_inf1528 = and i1 %6389, %6391, !dbg !1113
  %6392 = and i1 %is_zero1527, %is_inf1528, !dbg !1113
  %6393 = bitcast float %6289 to i32, !dbg !1113
  %6394 = and i32 %6393, 2139095040, !dbg !1113
  %6395 = icmp eq i32 %6394, 2139095040, !dbg !1113
  %6396 = and i32 %6393, 8388607, !dbg !1113
  %6397 = icmp eq i32 %6396, 0, !dbg !1113
  %is_inf1529 = and i1 %6395, %6397, !dbg !1113
  %6398 = bitcast float %6016 to i32, !dbg !1113
  %6399 = and i32 %6398, 2147483647, !dbg !1113
  %is_zero1530 = icmp eq i32 %6399, 0, !dbg !1113
  %6400 = and i1 %is_inf1529, %is_zero1530, !dbg !1113
  %6401 = or i1 %6392, %6400, !dbg !1113
  %6402 = or i1 %6384, %6401, !dbg !1113
  br i1 %6402, label %6403, label %6405, !dbg !1113

6403:                                             ; preds = %6366
  %6404 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6405, !dbg !1113

6405:                                             ; preds = %6366, %6403
  %6406 = call float @llvm.nvvm.fma.rn.f(float %6289, float %6016, float 0xBFC55B1720000000) #5, !dbg !1113
  %6407 = bitcast float %6289 to i32, !dbg !1113
  %6408 = and i32 %6407, 2139095040, !dbg !1113
  %is_finite1531 = icmp ne i32 %6408, 2139095040, !dbg !1113
  %6409 = and i1 true, %is_finite1531, !dbg !1113
  %6410 = bitcast float %6016 to i32, !dbg !1113
  %6411 = and i32 %6410, 2139095040, !dbg !1113
  %is_finite1532 = icmp ne i32 %6411, 2139095040, !dbg !1113
  %6412 = and i1 %6409, %is_finite1532, !dbg !1113
  %6413 = bitcast float %6406 to i32, !dbg !1113
  %6414 = and i32 %6413, 2139095040, !dbg !1113
  %6415 = icmp eq i32 %6414, 2139095040, !dbg !1113
  %6416 = and i32 %6413, 8388607, !dbg !1113
  %6417 = icmp eq i32 %6416, 0, !dbg !1113
  %is_inf1533 = and i1 %6415, %6417, !dbg !1113
  %6418 = bitcast float %6406 to i32, !dbg !1113
  %6419 = and i32 %6418, 2147483647, !dbg !1113
  %is_maxfinite1534 = icmp eq i32 %6419, 2139095039, !dbg !1113
  %6420 = bitcast float %6406 to i32, !dbg !1113
  %6421 = and i32 %6420, -2147483648, !dbg !1113
  %6422 = icmp eq i32 %6421, 0, !dbg !1113
  %6423 = icmp ne i32 %6421, 0, !dbg !1113
  %is_pos_inf1535 = and i1 %is_inf1533, %6422, !dbg !1113
  %is_neg_inf1536 = and i1 %is_inf1533, %6423, !dbg !1113
  %is_pos_max1537 = and i1 %is_maxfinite1534, %6422, !dbg !1113
  %is_neg_max1538 = and i1 %is_maxfinite1534, %6423, !dbg !1113
  %overflow_cond1539 = and i1 %6412, %is_inf1533, !dbg !1113
  br i1 %overflow_cond1539, label %6424, label %6426, !dbg !1113

6424:                                             ; preds = %6405
  %6425 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6426, !dbg !1113

6426:                                             ; preds = %6405, %6424
  %6427 = bitcast float %6289 to i32, !dbg !1113
  %6428 = and i32 %6427, 2139095040, !dbg !1113
  %6429 = icmp eq i32 %6428, 0, !dbg !1113
  %6430 = and i32 %6427, 8388607, !dbg !1113
  %6431 = icmp ne i32 %6430, 0, !dbg !1113
  %is_subnormal1540 = and i1 %6429, %6431, !dbg !1113
  %6432 = xor i1 %is_subnormal1540, true, !dbg !1113
  %6433 = and i1 true, %6432, !dbg !1113
  %6434 = bitcast float %6016 to i32, !dbg !1113
  %6435 = and i32 %6434, 2139095040, !dbg !1113
  %6436 = icmp eq i32 %6435, 0, !dbg !1113
  %6437 = and i32 %6434, 8388607, !dbg !1113
  %6438 = icmp ne i32 %6437, 0, !dbg !1113
  %is_subnormal1541 = and i1 %6436, %6438, !dbg !1113
  %6439 = xor i1 %is_subnormal1541, true, !dbg !1113
  %6440 = and i1 %6433, %6439, !dbg !1113
  %6441 = and i1 %6440, true, !dbg !1113
  %6442 = bitcast float %6406 to i32, !dbg !1113
  %6443 = and i32 %6442, 2139095040, !dbg !1113
  %6444 = icmp eq i32 %6443, 0, !dbg !1113
  %6445 = and i32 %6442, 8388607, !dbg !1113
  %6446 = icmp ne i32 %6445, 0, !dbg !1113
  %is_subnormal1542 = and i1 %6444, %6446, !dbg !1113
  %6447 = bitcast float %6406 to i32, !dbg !1113
  %6448 = and i32 %6447, 2147483647, !dbg !1113
  %is_zero1543 = icmp eq i32 %6448, 0, !dbg !1113
  %6449 = bitcast float %6289 to i32, !dbg !1113
  %6450 = and i32 %6449, 2147483647, !dbg !1113
  %is_zero1544 = icmp eq i32 %6450, 0, !dbg !1113
  %6451 = xor i1 %is_zero1544, true, !dbg !1113
  %6452 = bitcast float %6016 to i32, !dbg !1113
  %6453 = and i32 %6452, 2147483647, !dbg !1113
  %is_zero1545 = icmp eq i32 %6453, 0, !dbg !1113
  %6454 = xor i1 %is_zero1545, true, !dbg !1113
  %6455 = and i1 %6451, %6454, !dbg !1113
  %6456 = and i1 %6455, true, !dbg !1113
  %6457 = and i1 %is_zero1543, %6456, !dbg !1113
  %is_tiny1546 = or i1 %is_subnormal1542, %6457, !dbg !1113
  %underflow_cond1547 = and i1 %6441, %is_tiny1546, !dbg !1113
  br i1 %underflow_cond1547, label %6458, label %6460, !dbg !1113

6458:                                             ; preds = %6426
  %6459 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6460, !dbg !1113

6460:                                             ; preds = %6426, %6458
  %6461 = bitcast float %6289 to i32, !dbg !1113
  %6462 = and i32 %6461, 2139095040, !dbg !1113
  %6463 = icmp eq i32 %6462, 0, !dbg !1113
  %6464 = and i32 %6461, 8388607, !dbg !1113
  %6465 = icmp ne i32 %6464, 0, !dbg !1113
  %is_subnormal1548 = and i1 %6463, %6465, !dbg !1113
  %6466 = xor i1 %is_subnormal1548, true, !dbg !1113
  %6467 = and i1 true, %6466, !dbg !1113
  %6468 = bitcast float %6016 to i32, !dbg !1113
  %6469 = and i32 %6468, 2139095040, !dbg !1113
  %6470 = icmp eq i32 %6469, 0, !dbg !1113
  %6471 = and i32 %6468, 8388607, !dbg !1113
  %6472 = icmp ne i32 %6471, 0, !dbg !1113
  %is_subnormal1549 = and i1 %6470, %6472, !dbg !1113
  %6473 = xor i1 %is_subnormal1549, true, !dbg !1113
  %6474 = and i1 %6467, %6473, !dbg !1113
  %6475 = and i1 %6474, true, !dbg !1113
  %6476 = bitcast float %6406 to i32, !dbg !1113
  %6477 = and i32 %6476, 2139095040, !dbg !1113
  %6478 = icmp eq i32 %6477, 0, !dbg !1113
  %6479 = and i32 %6476, 8388607, !dbg !1113
  %6480 = icmp ne i32 %6479, 0, !dbg !1113
  %is_subnormal1550 = and i1 %6478, %6480, !dbg !1113
  %subnormal_cond1551 = and i1 %6475, %is_subnormal1550, !dbg !1113
  br i1 %subnormal_cond1551, label %6481, label %6483, !dbg !1113

6481:                                             ; preds = %6460
  %6482 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6483, !dbg !1113

6483:                                             ; preds = %6460, %6481
  %6484 = bitcast float %6406 to i32, !dbg !1113
  %6485 = bitcast float %6406 to i32, !dbg !1113
  %6486 = and i32 %6485, 2139095040, !dbg !1113
  %6487 = icmp eq i32 %6486, 2139095040, !dbg !1113
  %6488 = and i32 %6485, 8388607, !dbg !1113
  %6489 = icmp ne i32 %6488, 0, !dbg !1113
  %is_nan1552 = and i1 %6487, %6489, !dbg !1113
  %6490 = and i32 %6484, 4194304, !dbg !1113
  %6491 = icmp eq i32 %6490, 0, !dbg !1113
  %is_snan1553 = and i1 %is_nan1552, %6491, !dbg !1113
  %6492 = bitcast float %6016 to i32, !dbg !1113
  %6493 = bitcast float %6016 to i32, !dbg !1113
  %6494 = and i32 %6493, 2139095040, !dbg !1113
  %6495 = icmp eq i32 %6494, 2139095040, !dbg !1113
  %6496 = and i32 %6493, 8388607, !dbg !1113
  %6497 = icmp ne i32 %6496, 0, !dbg !1113
  %is_nan1554 = and i1 %6495, %6497, !dbg !1113
  %6498 = and i32 %6492, 4194304, !dbg !1113
  %6499 = icmp eq i32 %6498, 0, !dbg !1113
  %is_snan1555 = and i1 %is_nan1554, %6499, !dbg !1113
  %6500 = or i1 %is_snan1553, %is_snan1555, !dbg !1113
  %6501 = or i1 %6500, false, !dbg !1113
  %6502 = bitcast float %6406 to i32, !dbg !1113
  %6503 = and i32 %6502, 2147483647, !dbg !1113
  %is_zero1556 = icmp eq i32 %6503, 0, !dbg !1113
  %6504 = bitcast float %6016 to i32, !dbg !1113
  %6505 = and i32 %6504, 2139095040, !dbg !1113
  %6506 = icmp eq i32 %6505, 2139095040, !dbg !1113
  %6507 = and i32 %6504, 8388607, !dbg !1113
  %6508 = icmp eq i32 %6507, 0, !dbg !1113
  %is_inf1557 = and i1 %6506, %6508, !dbg !1113
  %6509 = and i1 %is_zero1556, %is_inf1557, !dbg !1113
  %6510 = bitcast float %6406 to i32, !dbg !1113
  %6511 = and i32 %6510, 2139095040, !dbg !1113
  %6512 = icmp eq i32 %6511, 2139095040, !dbg !1113
  %6513 = and i32 %6510, 8388607, !dbg !1113
  %6514 = icmp eq i32 %6513, 0, !dbg !1113
  %is_inf1558 = and i1 %6512, %6514, !dbg !1113
  %6515 = bitcast float %6016 to i32, !dbg !1113
  %6516 = and i32 %6515, 2147483647, !dbg !1113
  %is_zero1559 = icmp eq i32 %6516, 0, !dbg !1113
  %6517 = and i1 %is_inf1558, %is_zero1559, !dbg !1113
  %6518 = or i1 %6509, %6517, !dbg !1113
  %6519 = or i1 %6501, %6518, !dbg !1113
  br i1 %6519, label %6520, label %6522, !dbg !1113

6520:                                             ; preds = %6483
  %6521 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6522, !dbg !1113

6522:                                             ; preds = %6483, %6520
  %6523 = call float @llvm.nvvm.fma.rn.f(float %6406, float %6016, float 0x3FC99DA160000000) #5, !dbg !1113
  %6524 = bitcast float %6406 to i32, !dbg !1113
  %6525 = and i32 %6524, 2139095040, !dbg !1113
  %is_finite1560 = icmp ne i32 %6525, 2139095040, !dbg !1113
  %6526 = and i1 true, %is_finite1560, !dbg !1113
  %6527 = bitcast float %6016 to i32, !dbg !1113
  %6528 = and i32 %6527, 2139095040, !dbg !1113
  %is_finite1561 = icmp ne i32 %6528, 2139095040, !dbg !1113
  %6529 = and i1 %6526, %is_finite1561, !dbg !1113
  %6530 = bitcast float %6523 to i32, !dbg !1113
  %6531 = and i32 %6530, 2139095040, !dbg !1113
  %6532 = icmp eq i32 %6531, 2139095040, !dbg !1113
  %6533 = and i32 %6530, 8388607, !dbg !1113
  %6534 = icmp eq i32 %6533, 0, !dbg !1113
  %is_inf1562 = and i1 %6532, %6534, !dbg !1113
  %6535 = bitcast float %6523 to i32, !dbg !1113
  %6536 = and i32 %6535, 2147483647, !dbg !1113
  %is_maxfinite1563 = icmp eq i32 %6536, 2139095039, !dbg !1113
  %6537 = bitcast float %6523 to i32, !dbg !1113
  %6538 = and i32 %6537, -2147483648, !dbg !1113
  %6539 = icmp eq i32 %6538, 0, !dbg !1113
  %6540 = icmp ne i32 %6538, 0, !dbg !1113
  %is_pos_inf1564 = and i1 %is_inf1562, %6539, !dbg !1113
  %is_neg_inf1565 = and i1 %is_inf1562, %6540, !dbg !1113
  %is_pos_max1566 = and i1 %is_maxfinite1563, %6539, !dbg !1113
  %is_neg_max1567 = and i1 %is_maxfinite1563, %6540, !dbg !1113
  %overflow_cond1568 = and i1 %6529, %is_inf1562, !dbg !1113
  br i1 %overflow_cond1568, label %6541, label %6543, !dbg !1113

6541:                                             ; preds = %6522
  %6542 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6543, !dbg !1113

6543:                                             ; preds = %6522, %6541
  %6544 = bitcast float %6406 to i32, !dbg !1113
  %6545 = and i32 %6544, 2139095040, !dbg !1113
  %6546 = icmp eq i32 %6545, 0, !dbg !1113
  %6547 = and i32 %6544, 8388607, !dbg !1113
  %6548 = icmp ne i32 %6547, 0, !dbg !1113
  %is_subnormal1569 = and i1 %6546, %6548, !dbg !1113
  %6549 = xor i1 %is_subnormal1569, true, !dbg !1113
  %6550 = and i1 true, %6549, !dbg !1113
  %6551 = bitcast float %6016 to i32, !dbg !1113
  %6552 = and i32 %6551, 2139095040, !dbg !1113
  %6553 = icmp eq i32 %6552, 0, !dbg !1113
  %6554 = and i32 %6551, 8388607, !dbg !1113
  %6555 = icmp ne i32 %6554, 0, !dbg !1113
  %is_subnormal1570 = and i1 %6553, %6555, !dbg !1113
  %6556 = xor i1 %is_subnormal1570, true, !dbg !1113
  %6557 = and i1 %6550, %6556, !dbg !1113
  %6558 = and i1 %6557, true, !dbg !1113
  %6559 = bitcast float %6523 to i32, !dbg !1113
  %6560 = and i32 %6559, 2139095040, !dbg !1113
  %6561 = icmp eq i32 %6560, 0, !dbg !1113
  %6562 = and i32 %6559, 8388607, !dbg !1113
  %6563 = icmp ne i32 %6562, 0, !dbg !1113
  %is_subnormal1571 = and i1 %6561, %6563, !dbg !1113
  %6564 = bitcast float %6523 to i32, !dbg !1113
  %6565 = and i32 %6564, 2147483647, !dbg !1113
  %is_zero1572 = icmp eq i32 %6565, 0, !dbg !1113
  %6566 = bitcast float %6406 to i32, !dbg !1113
  %6567 = and i32 %6566, 2147483647, !dbg !1113
  %is_zero1573 = icmp eq i32 %6567, 0, !dbg !1113
  %6568 = xor i1 %is_zero1573, true, !dbg !1113
  %6569 = bitcast float %6016 to i32, !dbg !1113
  %6570 = and i32 %6569, 2147483647, !dbg !1113
  %is_zero1574 = icmp eq i32 %6570, 0, !dbg !1113
  %6571 = xor i1 %is_zero1574, true, !dbg !1113
  %6572 = and i1 %6568, %6571, !dbg !1113
  %6573 = and i1 %6572, true, !dbg !1113
  %6574 = and i1 %is_zero1572, %6573, !dbg !1113
  %is_tiny1575 = or i1 %is_subnormal1571, %6574, !dbg !1113
  %underflow_cond1576 = and i1 %6558, %is_tiny1575, !dbg !1113
  br i1 %underflow_cond1576, label %6575, label %6577, !dbg !1113

6575:                                             ; preds = %6543
  %6576 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6577, !dbg !1113

6577:                                             ; preds = %6543, %6575
  %6578 = bitcast float %6406 to i32, !dbg !1113
  %6579 = and i32 %6578, 2139095040, !dbg !1113
  %6580 = icmp eq i32 %6579, 0, !dbg !1113
  %6581 = and i32 %6578, 8388607, !dbg !1113
  %6582 = icmp ne i32 %6581, 0, !dbg !1113
  %is_subnormal1577 = and i1 %6580, %6582, !dbg !1113
  %6583 = xor i1 %is_subnormal1577, true, !dbg !1113
  %6584 = and i1 true, %6583, !dbg !1113
  %6585 = bitcast float %6016 to i32, !dbg !1113
  %6586 = and i32 %6585, 2139095040, !dbg !1113
  %6587 = icmp eq i32 %6586, 0, !dbg !1113
  %6588 = and i32 %6585, 8388607, !dbg !1113
  %6589 = icmp ne i32 %6588, 0, !dbg !1113
  %is_subnormal1578 = and i1 %6587, %6589, !dbg !1113
  %6590 = xor i1 %is_subnormal1578, true, !dbg !1113
  %6591 = and i1 %6584, %6590, !dbg !1113
  %6592 = and i1 %6591, true, !dbg !1113
  %6593 = bitcast float %6523 to i32, !dbg !1113
  %6594 = and i32 %6593, 2139095040, !dbg !1113
  %6595 = icmp eq i32 %6594, 0, !dbg !1113
  %6596 = and i32 %6593, 8388607, !dbg !1113
  %6597 = icmp ne i32 %6596, 0, !dbg !1113
  %is_subnormal1579 = and i1 %6595, %6597, !dbg !1113
  %subnormal_cond1580 = and i1 %6592, %is_subnormal1579, !dbg !1113
  br i1 %subnormal_cond1580, label %6598, label %6600, !dbg !1113

6598:                                             ; preds = %6577
  %6599 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6600, !dbg !1113

6600:                                             ; preds = %6577, %6598
  %6601 = bitcast float %6523 to i32, !dbg !1113
  %6602 = bitcast float %6523 to i32, !dbg !1113
  %6603 = and i32 %6602, 2139095040, !dbg !1113
  %6604 = icmp eq i32 %6603, 2139095040, !dbg !1113
  %6605 = and i32 %6602, 8388607, !dbg !1113
  %6606 = icmp ne i32 %6605, 0, !dbg !1113
  %is_nan1581 = and i1 %6604, %6606, !dbg !1113
  %6607 = and i32 %6601, 4194304, !dbg !1113
  %6608 = icmp eq i32 %6607, 0, !dbg !1113
  %is_snan1582 = and i1 %is_nan1581, %6608, !dbg !1113
  %6609 = bitcast float %6016 to i32, !dbg !1113
  %6610 = bitcast float %6016 to i32, !dbg !1113
  %6611 = and i32 %6610, 2139095040, !dbg !1113
  %6612 = icmp eq i32 %6611, 2139095040, !dbg !1113
  %6613 = and i32 %6610, 8388607, !dbg !1113
  %6614 = icmp ne i32 %6613, 0, !dbg !1113
  %is_nan1583 = and i1 %6612, %6614, !dbg !1113
  %6615 = and i32 %6609, 4194304, !dbg !1113
  %6616 = icmp eq i32 %6615, 0, !dbg !1113
  %is_snan1584 = and i1 %is_nan1583, %6616, !dbg !1113
  %6617 = or i1 %is_snan1582, %is_snan1584, !dbg !1113
  %6618 = or i1 %6617, false, !dbg !1113
  %6619 = bitcast float %6523 to i32, !dbg !1113
  %6620 = and i32 %6619, 2147483647, !dbg !1113
  %is_zero1585 = icmp eq i32 %6620, 0, !dbg !1113
  %6621 = bitcast float %6016 to i32, !dbg !1113
  %6622 = and i32 %6621, 2139095040, !dbg !1113
  %6623 = icmp eq i32 %6622, 2139095040, !dbg !1113
  %6624 = and i32 %6621, 8388607, !dbg !1113
  %6625 = icmp eq i32 %6624, 0, !dbg !1113
  %is_inf1586 = and i1 %6623, %6625, !dbg !1113
  %6626 = and i1 %is_zero1585, %is_inf1586, !dbg !1113
  %6627 = bitcast float %6523 to i32, !dbg !1113
  %6628 = and i32 %6627, 2139095040, !dbg !1113
  %6629 = icmp eq i32 %6628, 2139095040, !dbg !1113
  %6630 = and i32 %6627, 8388607, !dbg !1113
  %6631 = icmp eq i32 %6630, 0, !dbg !1113
  %is_inf1587 = and i1 %6629, %6631, !dbg !1113
  %6632 = bitcast float %6016 to i32, !dbg !1113
  %6633 = and i32 %6632, 2147483647, !dbg !1113
  %is_zero1588 = icmp eq i32 %6633, 0, !dbg !1113
  %6634 = and i1 %is_inf1587, %is_zero1588, !dbg !1113
  %6635 = or i1 %6626, %6634, !dbg !1113
  %6636 = or i1 %6618, %6635, !dbg !1113
  br i1 %6636, label %6637, label %6639, !dbg !1113

6637:                                             ; preds = %6600
  %6638 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6639, !dbg !1113

6639:                                             ; preds = %6600, %6637
  %6640 = call float @llvm.nvvm.fma.rn.f(float %6523, float %6016, float 0xBFCFFFE440000000) #5, !dbg !1113
  %6641 = bitcast float %6523 to i32, !dbg !1113
  %6642 = and i32 %6641, 2139095040, !dbg !1113
  %is_finite1589 = icmp ne i32 %6642, 2139095040, !dbg !1113
  %6643 = and i1 true, %is_finite1589, !dbg !1113
  %6644 = bitcast float %6016 to i32, !dbg !1113
  %6645 = and i32 %6644, 2139095040, !dbg !1113
  %is_finite1590 = icmp ne i32 %6645, 2139095040, !dbg !1113
  %6646 = and i1 %6643, %is_finite1590, !dbg !1113
  %6647 = bitcast float %6640 to i32, !dbg !1113
  %6648 = and i32 %6647, 2139095040, !dbg !1113
  %6649 = icmp eq i32 %6648, 2139095040, !dbg !1113
  %6650 = and i32 %6647, 8388607, !dbg !1113
  %6651 = icmp eq i32 %6650, 0, !dbg !1113
  %is_inf1591 = and i1 %6649, %6651, !dbg !1113
  %6652 = bitcast float %6640 to i32, !dbg !1113
  %6653 = and i32 %6652, 2147483647, !dbg !1113
  %is_maxfinite1592 = icmp eq i32 %6653, 2139095039, !dbg !1113
  %6654 = bitcast float %6640 to i32, !dbg !1113
  %6655 = and i32 %6654, -2147483648, !dbg !1113
  %6656 = icmp eq i32 %6655, 0, !dbg !1113
  %6657 = icmp ne i32 %6655, 0, !dbg !1113
  %is_pos_inf1593 = and i1 %is_inf1591, %6656, !dbg !1113
  %is_neg_inf1594 = and i1 %is_inf1591, %6657, !dbg !1113
  %is_pos_max1595 = and i1 %is_maxfinite1592, %6656, !dbg !1113
  %is_neg_max1596 = and i1 %is_maxfinite1592, %6657, !dbg !1113
  %overflow_cond1597 = and i1 %6646, %is_inf1591, !dbg !1113
  br i1 %overflow_cond1597, label %6658, label %6660, !dbg !1113

6658:                                             ; preds = %6639
  %6659 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6660, !dbg !1113

6660:                                             ; preds = %6639, %6658
  %6661 = bitcast float %6523 to i32, !dbg !1113
  %6662 = and i32 %6661, 2139095040, !dbg !1113
  %6663 = icmp eq i32 %6662, 0, !dbg !1113
  %6664 = and i32 %6661, 8388607, !dbg !1113
  %6665 = icmp ne i32 %6664, 0, !dbg !1113
  %is_subnormal1598 = and i1 %6663, %6665, !dbg !1113
  %6666 = xor i1 %is_subnormal1598, true, !dbg !1113
  %6667 = and i1 true, %6666, !dbg !1113
  %6668 = bitcast float %6016 to i32, !dbg !1113
  %6669 = and i32 %6668, 2139095040, !dbg !1113
  %6670 = icmp eq i32 %6669, 0, !dbg !1113
  %6671 = and i32 %6668, 8388607, !dbg !1113
  %6672 = icmp ne i32 %6671, 0, !dbg !1113
  %is_subnormal1599 = and i1 %6670, %6672, !dbg !1113
  %6673 = xor i1 %is_subnormal1599, true, !dbg !1113
  %6674 = and i1 %6667, %6673, !dbg !1113
  %6675 = and i1 %6674, true, !dbg !1113
  %6676 = bitcast float %6640 to i32, !dbg !1113
  %6677 = and i32 %6676, 2139095040, !dbg !1113
  %6678 = icmp eq i32 %6677, 0, !dbg !1113
  %6679 = and i32 %6676, 8388607, !dbg !1113
  %6680 = icmp ne i32 %6679, 0, !dbg !1113
  %is_subnormal1600 = and i1 %6678, %6680, !dbg !1113
  %6681 = bitcast float %6640 to i32, !dbg !1113
  %6682 = and i32 %6681, 2147483647, !dbg !1113
  %is_zero1601 = icmp eq i32 %6682, 0, !dbg !1113
  %6683 = bitcast float %6523 to i32, !dbg !1113
  %6684 = and i32 %6683, 2147483647, !dbg !1113
  %is_zero1602 = icmp eq i32 %6684, 0, !dbg !1113
  %6685 = xor i1 %is_zero1602, true, !dbg !1113
  %6686 = bitcast float %6016 to i32, !dbg !1113
  %6687 = and i32 %6686, 2147483647, !dbg !1113
  %is_zero1603 = icmp eq i32 %6687, 0, !dbg !1113
  %6688 = xor i1 %is_zero1603, true, !dbg !1113
  %6689 = and i1 %6685, %6688, !dbg !1113
  %6690 = and i1 %6689, true, !dbg !1113
  %6691 = and i1 %is_zero1601, %6690, !dbg !1113
  %is_tiny1604 = or i1 %is_subnormal1600, %6691, !dbg !1113
  %underflow_cond1605 = and i1 %6675, %is_tiny1604, !dbg !1113
  br i1 %underflow_cond1605, label %6692, label %6694, !dbg !1113

6692:                                             ; preds = %6660
  %6693 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6694, !dbg !1113

6694:                                             ; preds = %6660, %6692
  %6695 = bitcast float %6523 to i32, !dbg !1113
  %6696 = and i32 %6695, 2139095040, !dbg !1113
  %6697 = icmp eq i32 %6696, 0, !dbg !1113
  %6698 = and i32 %6695, 8388607, !dbg !1113
  %6699 = icmp ne i32 %6698, 0, !dbg !1113
  %is_subnormal1606 = and i1 %6697, %6699, !dbg !1113
  %6700 = xor i1 %is_subnormal1606, true, !dbg !1113
  %6701 = and i1 true, %6700, !dbg !1113
  %6702 = bitcast float %6016 to i32, !dbg !1113
  %6703 = and i32 %6702, 2139095040, !dbg !1113
  %6704 = icmp eq i32 %6703, 0, !dbg !1113
  %6705 = and i32 %6702, 8388607, !dbg !1113
  %6706 = icmp ne i32 %6705, 0, !dbg !1113
  %is_subnormal1607 = and i1 %6704, %6706, !dbg !1113
  %6707 = xor i1 %is_subnormal1607, true, !dbg !1113
  %6708 = and i1 %6701, %6707, !dbg !1113
  %6709 = and i1 %6708, true, !dbg !1113
  %6710 = bitcast float %6640 to i32, !dbg !1113
  %6711 = and i32 %6710, 2139095040, !dbg !1113
  %6712 = icmp eq i32 %6711, 0, !dbg !1113
  %6713 = and i32 %6710, 8388607, !dbg !1113
  %6714 = icmp ne i32 %6713, 0, !dbg !1113
  %is_subnormal1608 = and i1 %6712, %6714, !dbg !1113
  %subnormal_cond1609 = and i1 %6709, %is_subnormal1608, !dbg !1113
  br i1 %subnormal_cond1609, label %6715, label %6717, !dbg !1113

6715:                                             ; preds = %6694
  %6716 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6717, !dbg !1113

6717:                                             ; preds = %6694, %6715
  %6718 = bitcast float %6640 to i32, !dbg !1113
  %6719 = bitcast float %6640 to i32, !dbg !1113
  %6720 = and i32 %6719, 2139095040, !dbg !1113
  %6721 = icmp eq i32 %6720, 2139095040, !dbg !1113
  %6722 = and i32 %6719, 8388607, !dbg !1113
  %6723 = icmp ne i32 %6722, 0, !dbg !1113
  %is_nan1610 = and i1 %6721, %6723, !dbg !1113
  %6724 = and i32 %6718, 4194304, !dbg !1113
  %6725 = icmp eq i32 %6724, 0, !dbg !1113
  %is_snan1611 = and i1 %is_nan1610, %6725, !dbg !1113
  %6726 = bitcast float %6016 to i32, !dbg !1113
  %6727 = bitcast float %6016 to i32, !dbg !1113
  %6728 = and i32 %6727, 2139095040, !dbg !1113
  %6729 = icmp eq i32 %6728, 2139095040, !dbg !1113
  %6730 = and i32 %6727, 8388607, !dbg !1113
  %6731 = icmp ne i32 %6730, 0, !dbg !1113
  %is_nan1612 = and i1 %6729, %6731, !dbg !1113
  %6732 = and i32 %6726, 4194304, !dbg !1113
  %6733 = icmp eq i32 %6732, 0, !dbg !1113
  %is_snan1613 = and i1 %is_nan1612, %6733, !dbg !1113
  %6734 = or i1 %is_snan1611, %is_snan1613, !dbg !1113
  %6735 = or i1 %6734, false, !dbg !1113
  %6736 = bitcast float %6640 to i32, !dbg !1113
  %6737 = and i32 %6736, 2147483647, !dbg !1113
  %is_zero1614 = icmp eq i32 %6737, 0, !dbg !1113
  %6738 = bitcast float %6016 to i32, !dbg !1113
  %6739 = and i32 %6738, 2139095040, !dbg !1113
  %6740 = icmp eq i32 %6739, 2139095040, !dbg !1113
  %6741 = and i32 %6738, 8388607, !dbg !1113
  %6742 = icmp eq i32 %6741, 0, !dbg !1113
  %is_inf1615 = and i1 %6740, %6742, !dbg !1113
  %6743 = and i1 %is_zero1614, %is_inf1615, !dbg !1113
  %6744 = bitcast float %6640 to i32, !dbg !1113
  %6745 = and i32 %6744, 2139095040, !dbg !1113
  %6746 = icmp eq i32 %6745, 2139095040, !dbg !1113
  %6747 = and i32 %6744, 8388607, !dbg !1113
  %6748 = icmp eq i32 %6747, 0, !dbg !1113
  %is_inf1616 = and i1 %6746, %6748, !dbg !1113
  %6749 = bitcast float %6016 to i32, !dbg !1113
  %6750 = and i32 %6749, 2147483647, !dbg !1113
  %is_zero1617 = icmp eq i32 %6750, 0, !dbg !1113
  %6751 = and i1 %is_inf1616, %is_zero1617, !dbg !1113
  %6752 = or i1 %6743, %6751, !dbg !1113
  %6753 = or i1 %6735, %6752, !dbg !1113
  br i1 %6753, label %6754, label %6756, !dbg !1113

6754:                                             ; preds = %6717
  %6755 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6756, !dbg !1113

6756:                                             ; preds = %6717, %6754
  %6757 = call float @llvm.nvvm.fma.rn.f(float %6640, float %6016, float 0x3FD5554F00000000) #5, !dbg !1113
  %6758 = bitcast float %6640 to i32, !dbg !1113
  %6759 = and i32 %6758, 2139095040, !dbg !1113
  %is_finite1618 = icmp ne i32 %6759, 2139095040, !dbg !1113
  %6760 = and i1 true, %is_finite1618, !dbg !1113
  %6761 = bitcast float %6016 to i32, !dbg !1113
  %6762 = and i32 %6761, 2139095040, !dbg !1113
  %is_finite1619 = icmp ne i32 %6762, 2139095040, !dbg !1113
  %6763 = and i1 %6760, %is_finite1619, !dbg !1113
  %6764 = bitcast float %6757 to i32, !dbg !1113
  %6765 = and i32 %6764, 2139095040, !dbg !1113
  %6766 = icmp eq i32 %6765, 2139095040, !dbg !1113
  %6767 = and i32 %6764, 8388607, !dbg !1113
  %6768 = icmp eq i32 %6767, 0, !dbg !1113
  %is_inf1620 = and i1 %6766, %6768, !dbg !1113
  %6769 = bitcast float %6757 to i32, !dbg !1113
  %6770 = and i32 %6769, 2147483647, !dbg !1113
  %is_maxfinite1621 = icmp eq i32 %6770, 2139095039, !dbg !1113
  %6771 = bitcast float %6757 to i32, !dbg !1113
  %6772 = and i32 %6771, -2147483648, !dbg !1113
  %6773 = icmp eq i32 %6772, 0, !dbg !1113
  %6774 = icmp ne i32 %6772, 0, !dbg !1113
  %is_pos_inf1622 = and i1 %is_inf1620, %6773, !dbg !1113
  %is_neg_inf1623 = and i1 %is_inf1620, %6774, !dbg !1113
  %is_pos_max1624 = and i1 %is_maxfinite1621, %6773, !dbg !1113
  %is_neg_max1625 = and i1 %is_maxfinite1621, %6774, !dbg !1113
  %overflow_cond1626 = and i1 %6763, %is_inf1620, !dbg !1113
  br i1 %overflow_cond1626, label %6775, label %6777, !dbg !1113

6775:                                             ; preds = %6756
  %6776 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6777, !dbg !1113

6777:                                             ; preds = %6756, %6775
  %6778 = bitcast float %6640 to i32, !dbg !1113
  %6779 = and i32 %6778, 2139095040, !dbg !1113
  %6780 = icmp eq i32 %6779, 0, !dbg !1113
  %6781 = and i32 %6778, 8388607, !dbg !1113
  %6782 = icmp ne i32 %6781, 0, !dbg !1113
  %is_subnormal1627 = and i1 %6780, %6782, !dbg !1113
  %6783 = xor i1 %is_subnormal1627, true, !dbg !1113
  %6784 = and i1 true, %6783, !dbg !1113
  %6785 = bitcast float %6016 to i32, !dbg !1113
  %6786 = and i32 %6785, 2139095040, !dbg !1113
  %6787 = icmp eq i32 %6786, 0, !dbg !1113
  %6788 = and i32 %6785, 8388607, !dbg !1113
  %6789 = icmp ne i32 %6788, 0, !dbg !1113
  %is_subnormal1628 = and i1 %6787, %6789, !dbg !1113
  %6790 = xor i1 %is_subnormal1628, true, !dbg !1113
  %6791 = and i1 %6784, %6790, !dbg !1113
  %6792 = and i1 %6791, true, !dbg !1113
  %6793 = bitcast float %6757 to i32, !dbg !1113
  %6794 = and i32 %6793, 2139095040, !dbg !1113
  %6795 = icmp eq i32 %6794, 0, !dbg !1113
  %6796 = and i32 %6793, 8388607, !dbg !1113
  %6797 = icmp ne i32 %6796, 0, !dbg !1113
  %is_subnormal1629 = and i1 %6795, %6797, !dbg !1113
  %6798 = bitcast float %6757 to i32, !dbg !1113
  %6799 = and i32 %6798, 2147483647, !dbg !1113
  %is_zero1630 = icmp eq i32 %6799, 0, !dbg !1113
  %6800 = bitcast float %6640 to i32, !dbg !1113
  %6801 = and i32 %6800, 2147483647, !dbg !1113
  %is_zero1631 = icmp eq i32 %6801, 0, !dbg !1113
  %6802 = xor i1 %is_zero1631, true, !dbg !1113
  %6803 = bitcast float %6016 to i32, !dbg !1113
  %6804 = and i32 %6803, 2147483647, !dbg !1113
  %is_zero1632 = icmp eq i32 %6804, 0, !dbg !1113
  %6805 = xor i1 %is_zero1632, true, !dbg !1113
  %6806 = and i1 %6802, %6805, !dbg !1113
  %6807 = and i1 %6806, true, !dbg !1113
  %6808 = and i1 %is_zero1630, %6807, !dbg !1113
  %is_tiny1633 = or i1 %is_subnormal1629, %6808, !dbg !1113
  %underflow_cond1634 = and i1 %6792, %is_tiny1633, !dbg !1113
  br i1 %underflow_cond1634, label %6809, label %6811, !dbg !1113

6809:                                             ; preds = %6777
  %6810 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6811, !dbg !1113

6811:                                             ; preds = %6777, %6809
  %6812 = bitcast float %6640 to i32, !dbg !1113
  %6813 = and i32 %6812, 2139095040, !dbg !1113
  %6814 = icmp eq i32 %6813, 0, !dbg !1113
  %6815 = and i32 %6812, 8388607, !dbg !1113
  %6816 = icmp ne i32 %6815, 0, !dbg !1113
  %is_subnormal1635 = and i1 %6814, %6816, !dbg !1113
  %6817 = xor i1 %is_subnormal1635, true, !dbg !1113
  %6818 = and i1 true, %6817, !dbg !1113
  %6819 = bitcast float %6016 to i32, !dbg !1113
  %6820 = and i32 %6819, 2139095040, !dbg !1113
  %6821 = icmp eq i32 %6820, 0, !dbg !1113
  %6822 = and i32 %6819, 8388607, !dbg !1113
  %6823 = icmp ne i32 %6822, 0, !dbg !1113
  %is_subnormal1636 = and i1 %6821, %6823, !dbg !1113
  %6824 = xor i1 %is_subnormal1636, true, !dbg !1113
  %6825 = and i1 %6818, %6824, !dbg !1113
  %6826 = and i1 %6825, true, !dbg !1113
  %6827 = bitcast float %6757 to i32, !dbg !1113
  %6828 = and i32 %6827, 2139095040, !dbg !1113
  %6829 = icmp eq i32 %6828, 0, !dbg !1113
  %6830 = and i32 %6827, 8388607, !dbg !1113
  %6831 = icmp ne i32 %6830, 0, !dbg !1113
  %is_subnormal1637 = and i1 %6829, %6831, !dbg !1113
  %subnormal_cond1638 = and i1 %6826, %is_subnormal1637, !dbg !1113
  br i1 %subnormal_cond1638, label %6832, label %6834, !dbg !1113

6832:                                             ; preds = %6811
  %6833 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6834, !dbg !1113

6834:                                             ; preds = %6811, %6832
  %6835 = bitcast float %6757 to i32, !dbg !1113
  %6836 = bitcast float %6757 to i32, !dbg !1113
  %6837 = and i32 %6836, 2139095040, !dbg !1113
  %6838 = icmp eq i32 %6837, 2139095040, !dbg !1113
  %6839 = and i32 %6836, 8388607, !dbg !1113
  %6840 = icmp ne i32 %6839, 0, !dbg !1113
  %is_nan1639 = and i1 %6838, %6840, !dbg !1113
  %6841 = and i32 %6835, 4194304, !dbg !1113
  %6842 = icmp eq i32 %6841, 0, !dbg !1113
  %is_snan1640 = and i1 %is_nan1639, %6842, !dbg !1113
  %6843 = bitcast float %6016 to i32, !dbg !1113
  %6844 = bitcast float %6016 to i32, !dbg !1113
  %6845 = and i32 %6844, 2139095040, !dbg !1113
  %6846 = icmp eq i32 %6845, 2139095040, !dbg !1113
  %6847 = and i32 %6844, 8388607, !dbg !1113
  %6848 = icmp ne i32 %6847, 0, !dbg !1113
  %is_nan1641 = and i1 %6846, %6848, !dbg !1113
  %6849 = and i32 %6843, 4194304, !dbg !1113
  %6850 = icmp eq i32 %6849, 0, !dbg !1113
  %is_snan1642 = and i1 %is_nan1641, %6850, !dbg !1113
  %6851 = or i1 %is_snan1640, %is_snan1642, !dbg !1113
  %6852 = or i1 %6851, false, !dbg !1113
  %6853 = bitcast float %6757 to i32, !dbg !1113
  %6854 = and i32 %6853, 2147483647, !dbg !1113
  %is_zero1643 = icmp eq i32 %6854, 0, !dbg !1113
  %6855 = bitcast float %6016 to i32, !dbg !1113
  %6856 = and i32 %6855, 2139095040, !dbg !1113
  %6857 = icmp eq i32 %6856, 2139095040, !dbg !1113
  %6858 = and i32 %6855, 8388607, !dbg !1113
  %6859 = icmp eq i32 %6858, 0, !dbg !1113
  %is_inf1644 = and i1 %6857, %6859, !dbg !1113
  %6860 = and i1 %is_zero1643, %is_inf1644, !dbg !1113
  %6861 = bitcast float %6757 to i32, !dbg !1113
  %6862 = and i32 %6861, 2139095040, !dbg !1113
  %6863 = icmp eq i32 %6862, 2139095040, !dbg !1113
  %6864 = and i32 %6861, 8388607, !dbg !1113
  %6865 = icmp eq i32 %6864, 0, !dbg !1113
  %is_inf1645 = and i1 %6863, %6865, !dbg !1113
  %6866 = bitcast float %6016 to i32, !dbg !1113
  %6867 = and i32 %6866, 2147483647, !dbg !1113
  %is_zero1646 = icmp eq i32 %6867, 0, !dbg !1113
  %6868 = and i1 %is_inf1645, %is_zero1646, !dbg !1113
  %6869 = or i1 %6860, %6868, !dbg !1113
  %6870 = or i1 %6852, %6869, !dbg !1113
  br i1 %6870, label %6871, label %6873, !dbg !1113

6871:                                             ; preds = %6834
  %6872 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6873, !dbg !1113

6873:                                             ; preds = %6834, %6871
  %6874 = call float @llvm.nvvm.fma.rn.f(float %6757, float %6016, float -5.000000e-01) #5, !dbg !1113
  %6875 = bitcast float %6757 to i32, !dbg !1113
  %6876 = and i32 %6875, 2139095040, !dbg !1113
  %is_finite1647 = icmp ne i32 %6876, 2139095040, !dbg !1113
  %6877 = and i1 true, %is_finite1647, !dbg !1113
  %6878 = bitcast float %6016 to i32, !dbg !1113
  %6879 = and i32 %6878, 2139095040, !dbg !1113
  %is_finite1648 = icmp ne i32 %6879, 2139095040, !dbg !1113
  %6880 = and i1 %6877, %is_finite1648, !dbg !1113
  %6881 = bitcast float %6874 to i32, !dbg !1113
  %6882 = and i32 %6881, 2139095040, !dbg !1113
  %6883 = icmp eq i32 %6882, 2139095040, !dbg !1113
  %6884 = and i32 %6881, 8388607, !dbg !1113
  %6885 = icmp eq i32 %6884, 0, !dbg !1113
  %is_inf1649 = and i1 %6883, %6885, !dbg !1113
  %6886 = bitcast float %6874 to i32, !dbg !1113
  %6887 = and i32 %6886, 2147483647, !dbg !1113
  %is_maxfinite1650 = icmp eq i32 %6887, 2139095039, !dbg !1113
  %6888 = bitcast float %6874 to i32, !dbg !1113
  %6889 = and i32 %6888, -2147483648, !dbg !1113
  %6890 = icmp eq i32 %6889, 0, !dbg !1113
  %6891 = icmp ne i32 %6889, 0, !dbg !1113
  %is_pos_inf1651 = and i1 %is_inf1649, %6890, !dbg !1113
  %is_neg_inf1652 = and i1 %is_inf1649, %6891, !dbg !1113
  %is_pos_max1653 = and i1 %is_maxfinite1650, %6890, !dbg !1113
  %is_neg_max1654 = and i1 %is_maxfinite1650, %6891, !dbg !1113
  %overflow_cond1655 = and i1 %6880, %is_inf1649, !dbg !1113
  br i1 %overflow_cond1655, label %6892, label %6894, !dbg !1113

6892:                                             ; preds = %6873
  %6893 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %6894, !dbg !1113

6894:                                             ; preds = %6873, %6892
  %6895 = bitcast float %6757 to i32, !dbg !1113
  %6896 = and i32 %6895, 2139095040, !dbg !1113
  %6897 = icmp eq i32 %6896, 0, !dbg !1113
  %6898 = and i32 %6895, 8388607, !dbg !1113
  %6899 = icmp ne i32 %6898, 0, !dbg !1113
  %is_subnormal1656 = and i1 %6897, %6899, !dbg !1113
  %6900 = xor i1 %is_subnormal1656, true, !dbg !1113
  %6901 = and i1 true, %6900, !dbg !1113
  %6902 = bitcast float %6016 to i32, !dbg !1113
  %6903 = and i32 %6902, 2139095040, !dbg !1113
  %6904 = icmp eq i32 %6903, 0, !dbg !1113
  %6905 = and i32 %6902, 8388607, !dbg !1113
  %6906 = icmp ne i32 %6905, 0, !dbg !1113
  %is_subnormal1657 = and i1 %6904, %6906, !dbg !1113
  %6907 = xor i1 %is_subnormal1657, true, !dbg !1113
  %6908 = and i1 %6901, %6907, !dbg !1113
  %6909 = and i1 %6908, true, !dbg !1113
  %6910 = bitcast float %6874 to i32, !dbg !1113
  %6911 = and i32 %6910, 2139095040, !dbg !1113
  %6912 = icmp eq i32 %6911, 0, !dbg !1113
  %6913 = and i32 %6910, 8388607, !dbg !1113
  %6914 = icmp ne i32 %6913, 0, !dbg !1113
  %is_subnormal1658 = and i1 %6912, %6914, !dbg !1113
  %6915 = bitcast float %6874 to i32, !dbg !1113
  %6916 = and i32 %6915, 2147483647, !dbg !1113
  %is_zero1659 = icmp eq i32 %6916, 0, !dbg !1113
  %6917 = bitcast float %6757 to i32, !dbg !1113
  %6918 = and i32 %6917, 2147483647, !dbg !1113
  %is_zero1660 = icmp eq i32 %6918, 0, !dbg !1113
  %6919 = xor i1 %is_zero1660, true, !dbg !1113
  %6920 = bitcast float %6016 to i32, !dbg !1113
  %6921 = and i32 %6920, 2147483647, !dbg !1113
  %is_zero1661 = icmp eq i32 %6921, 0, !dbg !1113
  %6922 = xor i1 %is_zero1661, true, !dbg !1113
  %6923 = and i1 %6919, %6922, !dbg !1113
  %6924 = and i1 %6923, true, !dbg !1113
  %6925 = and i1 %is_zero1659, %6924, !dbg !1113
  %is_tiny1662 = or i1 %is_subnormal1658, %6925, !dbg !1113
  %underflow_cond1663 = and i1 %6909, %is_tiny1662, !dbg !1113
  br i1 %underflow_cond1663, label %6926, label %6928, !dbg !1113

6926:                                             ; preds = %6894
  %6927 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %6928, !dbg !1113

6928:                                             ; preds = %6894, %6926
  %6929 = bitcast float %6757 to i32, !dbg !1113
  %6930 = and i32 %6929, 2139095040, !dbg !1113
  %6931 = icmp eq i32 %6930, 0, !dbg !1113
  %6932 = and i32 %6929, 8388607, !dbg !1113
  %6933 = icmp ne i32 %6932, 0, !dbg !1113
  %is_subnormal1664 = and i1 %6931, %6933, !dbg !1113
  %6934 = xor i1 %is_subnormal1664, true, !dbg !1113
  %6935 = and i1 true, %6934, !dbg !1113
  %6936 = bitcast float %6016 to i32, !dbg !1113
  %6937 = and i32 %6936, 2139095040, !dbg !1113
  %6938 = icmp eq i32 %6937, 0, !dbg !1113
  %6939 = and i32 %6936, 8388607, !dbg !1113
  %6940 = icmp ne i32 %6939, 0, !dbg !1113
  %is_subnormal1665 = and i1 %6938, %6940, !dbg !1113
  %6941 = xor i1 %is_subnormal1665, true, !dbg !1113
  %6942 = and i1 %6935, %6941, !dbg !1113
  %6943 = and i1 %6942, true, !dbg !1113
  %6944 = bitcast float %6874 to i32, !dbg !1113
  %6945 = and i32 %6944, 2139095040, !dbg !1113
  %6946 = icmp eq i32 %6945, 0, !dbg !1113
  %6947 = and i32 %6944, 8388607, !dbg !1113
  %6948 = icmp ne i32 %6947, 0, !dbg !1113
  %is_subnormal1666 = and i1 %6946, %6948, !dbg !1113
  %subnormal_cond1667 = and i1 %6943, %is_subnormal1666, !dbg !1113
  br i1 %subnormal_cond1667, label %6949, label %6951, !dbg !1113

6949:                                             ; preds = %6928
  %6950 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %6951, !dbg !1113

6951:                                             ; preds = %6928, %6949
  %6952 = bitcast float %6874 to i32, !dbg !1113
  %6953 = bitcast float %6874 to i32, !dbg !1113
  %6954 = and i32 %6953, 2139095040, !dbg !1113
  %6955 = icmp eq i32 %6954, 2139095040, !dbg !1113
  %6956 = and i32 %6953, 8388607, !dbg !1113
  %6957 = icmp ne i32 %6956, 0, !dbg !1113
  %is_nan1668 = and i1 %6955, %6957, !dbg !1113
  %6958 = and i32 %6952, 4194304, !dbg !1113
  %6959 = icmp eq i32 %6958, 0, !dbg !1113
  %is_snan1669 = and i1 %is_nan1668, %6959, !dbg !1113
  %6960 = bitcast float %6016 to i32, !dbg !1113
  %6961 = bitcast float %6016 to i32, !dbg !1113
  %6962 = and i32 %6961, 2139095040, !dbg !1113
  %6963 = icmp eq i32 %6962, 2139095040, !dbg !1113
  %6964 = and i32 %6961, 8388607, !dbg !1113
  %6965 = icmp ne i32 %6964, 0, !dbg !1113
  %is_nan1670 = and i1 %6963, %6965, !dbg !1113
  %6966 = and i32 %6960, 4194304, !dbg !1113
  %6967 = icmp eq i32 %6966, 0, !dbg !1113
  %is_snan1671 = and i1 %is_nan1670, %6967, !dbg !1113
  %6968 = or i1 %is_snan1669, %is_snan1671, !dbg !1113
  %6969 = bitcast float %6874 to i32, !dbg !1113
  %6970 = and i32 %6969, 2147483647, !dbg !1113
  %is_zero1672 = icmp eq i32 %6970, 0, !dbg !1113
  %6971 = bitcast float %6016 to i32, !dbg !1113
  %6972 = and i32 %6971, 2139095040, !dbg !1113
  %6973 = icmp eq i32 %6972, 2139095040, !dbg !1113
  %6974 = and i32 %6971, 8388607, !dbg !1113
  %6975 = icmp eq i32 %6974, 0, !dbg !1113
  %is_inf1673 = and i1 %6973, %6975, !dbg !1113
  %6976 = and i1 %is_zero1672, %is_inf1673, !dbg !1113
  %6977 = bitcast float %6874 to i32, !dbg !1113
  %6978 = and i32 %6977, 2139095040, !dbg !1113
  %6979 = icmp eq i32 %6978, 2139095040, !dbg !1113
  %6980 = and i32 %6977, 8388607, !dbg !1113
  %6981 = icmp eq i32 %6980, 0, !dbg !1113
  %is_inf1674 = and i1 %6979, %6981, !dbg !1113
  %6982 = bitcast float %6016 to i32, !dbg !1113
  %6983 = and i32 %6982, 2147483647, !dbg !1113
  %is_zero1675 = icmp eq i32 %6983, 0, !dbg !1113
  %6984 = and i1 %is_inf1674, %is_zero1675, !dbg !1113
  %6985 = or i1 %6976, %6984, !dbg !1113
  %6986 = or i1 %6968, %6985, !dbg !1113
  br i1 %6986, label %6987, label %6989, !dbg !1113

6987:                                             ; preds = %6951
  %6988 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %6989, !dbg !1113

6989:                                             ; preds = %6951, %6987
  %6990 = fmul float %6874, %6016, !dbg !1113
  %6991 = bitcast float %6874 to i32, !dbg !1113
  %6992 = and i32 %6991, 2139095040, !dbg !1113
  %is_finite1676 = icmp ne i32 %6992, 2139095040, !dbg !1113
  %6993 = and i1 true, %is_finite1676, !dbg !1113
  %6994 = bitcast float %6016 to i32, !dbg !1113
  %6995 = and i32 %6994, 2139095040, !dbg !1113
  %is_finite1677 = icmp ne i32 %6995, 2139095040, !dbg !1113
  %6996 = and i1 %6993, %is_finite1677, !dbg !1113
  %6997 = bitcast float %6990 to i32, !dbg !1113
  %6998 = and i32 %6997, 2139095040, !dbg !1113
  %6999 = icmp eq i32 %6998, 2139095040, !dbg !1113
  %7000 = and i32 %6997, 8388607, !dbg !1113
  %7001 = icmp eq i32 %7000, 0, !dbg !1113
  %is_inf1678 = and i1 %6999, %7001, !dbg !1113
  %7002 = bitcast float %6990 to i32, !dbg !1113
  %7003 = and i32 %7002, 2147483647, !dbg !1113
  %is_maxfinite1679 = icmp eq i32 %7003, 2139095039, !dbg !1113
  %7004 = bitcast float %6990 to i32, !dbg !1113
  %7005 = and i32 %7004, -2147483648, !dbg !1113
  %7006 = icmp eq i32 %7005, 0, !dbg !1113
  %7007 = icmp ne i32 %7005, 0, !dbg !1113
  %is_pos_inf1680 = and i1 %is_inf1678, %7006, !dbg !1113
  %is_neg_inf1681 = and i1 %is_inf1678, %7007, !dbg !1113
  %is_pos_max1682 = and i1 %is_maxfinite1679, %7006, !dbg !1113
  %is_neg_max1683 = and i1 %is_maxfinite1679, %7007, !dbg !1113
  %overflow_cond1684 = and i1 %6996, %is_inf1678, !dbg !1113
  br i1 %overflow_cond1684, label %7008, label %7010, !dbg !1113

7008:                                             ; preds = %6989
  %7009 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %7010, !dbg !1113

7010:                                             ; preds = %6989, %7008
  %7011 = bitcast float %6874 to i32, !dbg !1113
  %7012 = and i32 %7011, 2139095040, !dbg !1113
  %7013 = icmp eq i32 %7012, 0, !dbg !1113
  %7014 = and i32 %7011, 8388607, !dbg !1113
  %7015 = icmp ne i32 %7014, 0, !dbg !1113
  %is_subnormal1685 = and i1 %7013, %7015, !dbg !1113
  %7016 = xor i1 %is_subnormal1685, true, !dbg !1113
  %7017 = and i1 true, %7016, !dbg !1113
  %7018 = bitcast float %6016 to i32, !dbg !1113
  %7019 = and i32 %7018, 2139095040, !dbg !1113
  %7020 = icmp eq i32 %7019, 0, !dbg !1113
  %7021 = and i32 %7018, 8388607, !dbg !1113
  %7022 = icmp ne i32 %7021, 0, !dbg !1113
  %is_subnormal1686 = and i1 %7020, %7022, !dbg !1113
  %7023 = xor i1 %is_subnormal1686, true, !dbg !1113
  %7024 = and i1 %7017, %7023, !dbg !1113
  %7025 = bitcast float %6990 to i32, !dbg !1113
  %7026 = and i32 %7025, 2139095040, !dbg !1113
  %7027 = icmp eq i32 %7026, 0, !dbg !1113
  %7028 = and i32 %7025, 8388607, !dbg !1113
  %7029 = icmp ne i32 %7028, 0, !dbg !1113
  %is_subnormal1687 = and i1 %7027, %7029, !dbg !1113
  %7030 = bitcast float %6990 to i32, !dbg !1113
  %7031 = and i32 %7030, 2147483647, !dbg !1113
  %is_zero1688 = icmp eq i32 %7031, 0, !dbg !1113
  %7032 = bitcast float %6874 to i32, !dbg !1113
  %7033 = and i32 %7032, 2147483647, !dbg !1113
  %is_zero1689 = icmp eq i32 %7033, 0, !dbg !1113
  %7034 = xor i1 %is_zero1689, true, !dbg !1113
  %7035 = bitcast float %6016 to i32, !dbg !1113
  %7036 = and i32 %7035, 2147483647, !dbg !1113
  %is_zero1690 = icmp eq i32 %7036, 0, !dbg !1113
  %7037 = xor i1 %is_zero1690, true, !dbg !1113
  %7038 = and i1 %7034, %7037, !dbg !1113
  %7039 = and i1 %is_zero1688, %7038, !dbg !1113
  %is_tiny1691 = or i1 %is_subnormal1687, %7039, !dbg !1113
  %underflow_cond1692 = and i1 %7024, %is_tiny1691, !dbg !1113
  br i1 %underflow_cond1692, label %7040, label %7042, !dbg !1113

7040:                                             ; preds = %7010
  %7041 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %7042, !dbg !1113

7042:                                             ; preds = %7010, %7040
  %7043 = bitcast float %6874 to i32, !dbg !1113
  %7044 = and i32 %7043, 2139095040, !dbg !1113
  %7045 = icmp eq i32 %7044, 0, !dbg !1113
  %7046 = and i32 %7043, 8388607, !dbg !1113
  %7047 = icmp ne i32 %7046, 0, !dbg !1113
  %is_subnormal1693 = and i1 %7045, %7047, !dbg !1113
  %7048 = xor i1 %is_subnormal1693, true, !dbg !1113
  %7049 = and i1 true, %7048, !dbg !1113
  %7050 = bitcast float %6016 to i32, !dbg !1113
  %7051 = and i32 %7050, 2139095040, !dbg !1113
  %7052 = icmp eq i32 %7051, 0, !dbg !1113
  %7053 = and i32 %7050, 8388607, !dbg !1113
  %7054 = icmp ne i32 %7053, 0, !dbg !1113
  %is_subnormal1694 = and i1 %7052, %7054, !dbg !1113
  %7055 = xor i1 %is_subnormal1694, true, !dbg !1113
  %7056 = and i1 %7049, %7055, !dbg !1113
  %7057 = bitcast float %6990 to i32, !dbg !1113
  %7058 = and i32 %7057, 2139095040, !dbg !1113
  %7059 = icmp eq i32 %7058, 0, !dbg !1113
  %7060 = and i32 %7057, 8388607, !dbg !1113
  %7061 = icmp ne i32 %7060, 0, !dbg !1113
  %is_subnormal1695 = and i1 %7059, %7061, !dbg !1113
  %subnormal_cond1696 = and i1 %7056, %is_subnormal1695, !dbg !1113
  br i1 %subnormal_cond1696, label %7062, label %7064, !dbg !1113

7062:                                             ; preds = %7042
  %7063 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %7064, !dbg !1113

7064:                                             ; preds = %7042, %7062
  %7065 = bitcast float %6990 to i32, !dbg !1113
  %7066 = bitcast float %6990 to i32, !dbg !1113
  %7067 = and i32 %7066, 2139095040, !dbg !1113
  %7068 = icmp eq i32 %7067, 2139095040, !dbg !1113
  %7069 = and i32 %7066, 8388607, !dbg !1113
  %7070 = icmp ne i32 %7069, 0, !dbg !1113
  %is_nan1697 = and i1 %7068, %7070, !dbg !1113
  %7071 = and i32 %7065, 4194304, !dbg !1113
  %7072 = icmp eq i32 %7071, 0, !dbg !1113
  %is_snan1698 = and i1 %is_nan1697, %7072, !dbg !1113
  %7073 = bitcast float %6016 to i32, !dbg !1113
  %7074 = bitcast float %6016 to i32, !dbg !1113
  %7075 = and i32 %7074, 2139095040, !dbg !1113
  %7076 = icmp eq i32 %7075, 2139095040, !dbg !1113
  %7077 = and i32 %7074, 8388607, !dbg !1113
  %7078 = icmp ne i32 %7077, 0, !dbg !1113
  %is_nan1699 = and i1 %7076, %7078, !dbg !1113
  %7079 = and i32 %7073, 4194304, !dbg !1113
  %7080 = icmp eq i32 %7079, 0, !dbg !1113
  %is_snan1700 = and i1 %is_nan1699, %7080, !dbg !1113
  %7081 = or i1 %is_snan1698, %is_snan1700, !dbg !1113
  %7082 = bitcast float %6016 to i32, !dbg !1113
  %7083 = bitcast float %6016 to i32, !dbg !1113
  %7084 = and i32 %7083, 2139095040, !dbg !1113
  %7085 = icmp eq i32 %7084, 2139095040, !dbg !1113
  %7086 = and i32 %7083, 8388607, !dbg !1113
  %7087 = icmp ne i32 %7086, 0, !dbg !1113
  %is_nan1701 = and i1 %7085, %7087, !dbg !1113
  %7088 = and i32 %7082, 4194304, !dbg !1113
  %7089 = icmp eq i32 %7088, 0, !dbg !1113
  %is_snan1702 = and i1 %is_nan1701, %7089, !dbg !1113
  %7090 = or i1 %7081, %is_snan1702, !dbg !1113
  %7091 = bitcast float %6990 to i32, !dbg !1113
  %7092 = and i32 %7091, 2147483647, !dbg !1113
  %is_zero1703 = icmp eq i32 %7092, 0, !dbg !1113
  %7093 = bitcast float %6016 to i32, !dbg !1113
  %7094 = and i32 %7093, 2139095040, !dbg !1113
  %7095 = icmp eq i32 %7094, 2139095040, !dbg !1113
  %7096 = and i32 %7093, 8388607, !dbg !1113
  %7097 = icmp eq i32 %7096, 0, !dbg !1113
  %is_inf1704 = and i1 %7095, %7097, !dbg !1113
  %7098 = and i1 %is_zero1703, %is_inf1704, !dbg !1113
  %7099 = bitcast float %6990 to i32, !dbg !1113
  %7100 = and i32 %7099, 2139095040, !dbg !1113
  %7101 = icmp eq i32 %7100, 2139095040, !dbg !1113
  %7102 = and i32 %7099, 8388607, !dbg !1113
  %7103 = icmp eq i32 %7102, 0, !dbg !1113
  %is_inf1705 = and i1 %7101, %7103, !dbg !1113
  %7104 = bitcast float %6016 to i32, !dbg !1113
  %7105 = and i32 %7104, 2147483647, !dbg !1113
  %is_zero1706 = icmp eq i32 %7105, 0, !dbg !1113
  %7106 = and i1 %is_inf1705, %is_zero1706, !dbg !1113
  %7107 = or i1 %7098, %7106, !dbg !1113
  %7108 = or i1 %7090, %7107, !dbg !1113
  br i1 %7108, label %7109, label %7111, !dbg !1113

7109:                                             ; preds = %7064
  %7110 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %7111, !dbg !1113

7111:                                             ; preds = %7064, %7109
  %7112 = call float @llvm.nvvm.fma.rn.f(float %6990, float %6016, float %6016) #5, !dbg !1113
  %7113 = bitcast float %6990 to i32, !dbg !1113
  %7114 = and i32 %7113, 2139095040, !dbg !1113
  %is_finite1707 = icmp ne i32 %7114, 2139095040, !dbg !1113
  %7115 = and i1 true, %is_finite1707, !dbg !1113
  %7116 = bitcast float %6016 to i32, !dbg !1113
  %7117 = and i32 %7116, 2139095040, !dbg !1113
  %is_finite1708 = icmp ne i32 %7117, 2139095040, !dbg !1113
  %7118 = and i1 %7115, %is_finite1708, !dbg !1113
  %7119 = bitcast float %7112 to i32, !dbg !1113
  %7120 = and i32 %7119, 2139095040, !dbg !1113
  %7121 = icmp eq i32 %7120, 2139095040, !dbg !1113
  %7122 = and i32 %7119, 8388607, !dbg !1113
  %7123 = icmp eq i32 %7122, 0, !dbg !1113
  %is_inf1709 = and i1 %7121, %7123, !dbg !1113
  %7124 = bitcast float %7112 to i32, !dbg !1113
  %7125 = and i32 %7124, 2147483647, !dbg !1113
  %is_maxfinite1710 = icmp eq i32 %7125, 2139095039, !dbg !1113
  %7126 = bitcast float %7112 to i32, !dbg !1113
  %7127 = and i32 %7126, -2147483648, !dbg !1113
  %7128 = icmp eq i32 %7127, 0, !dbg !1113
  %7129 = icmp ne i32 %7127, 0, !dbg !1113
  %is_pos_inf1711 = and i1 %is_inf1709, %7128, !dbg !1113
  %is_neg_inf1712 = and i1 %is_inf1709, %7129, !dbg !1113
  %is_pos_max1713 = and i1 %is_maxfinite1710, %7128, !dbg !1113
  %is_neg_max1714 = and i1 %is_maxfinite1710, %7129, !dbg !1113
  %overflow_cond1715 = and i1 %7118, %is_inf1709, !dbg !1113
  br i1 %overflow_cond1715, label %7130, label %7132, !dbg !1113

7130:                                             ; preds = %7111
  %7131 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %7132, !dbg !1113

7132:                                             ; preds = %7111, %7130
  %7133 = bitcast float %6990 to i32, !dbg !1113
  %7134 = and i32 %7133, 2139095040, !dbg !1113
  %7135 = icmp eq i32 %7134, 0, !dbg !1113
  %7136 = and i32 %7133, 8388607, !dbg !1113
  %7137 = icmp ne i32 %7136, 0, !dbg !1113
  %is_subnormal1716 = and i1 %7135, %7137, !dbg !1113
  %7138 = xor i1 %is_subnormal1716, true, !dbg !1113
  %7139 = and i1 true, %7138, !dbg !1113
  %7140 = bitcast float %6016 to i32, !dbg !1113
  %7141 = and i32 %7140, 2139095040, !dbg !1113
  %7142 = icmp eq i32 %7141, 0, !dbg !1113
  %7143 = and i32 %7140, 8388607, !dbg !1113
  %7144 = icmp ne i32 %7143, 0, !dbg !1113
  %is_subnormal1717 = and i1 %7142, %7144, !dbg !1113
  %7145 = xor i1 %is_subnormal1717, true, !dbg !1113
  %7146 = and i1 %7139, %7145, !dbg !1113
  %7147 = bitcast float %6016 to i32, !dbg !1113
  %7148 = and i32 %7147, 2139095040, !dbg !1113
  %7149 = icmp eq i32 %7148, 0, !dbg !1113
  %7150 = and i32 %7147, 8388607, !dbg !1113
  %7151 = icmp ne i32 %7150, 0, !dbg !1113
  %is_subnormal1718 = and i1 %7149, %7151, !dbg !1113
  %7152 = xor i1 %is_subnormal1718, true, !dbg !1113
  %7153 = and i1 %7146, %7152, !dbg !1113
  %7154 = bitcast float %7112 to i32, !dbg !1113
  %7155 = and i32 %7154, 2139095040, !dbg !1113
  %7156 = icmp eq i32 %7155, 0, !dbg !1113
  %7157 = and i32 %7154, 8388607, !dbg !1113
  %7158 = icmp ne i32 %7157, 0, !dbg !1113
  %is_subnormal1719 = and i1 %7156, %7158, !dbg !1113
  %7159 = bitcast float %7112 to i32, !dbg !1113
  %7160 = and i32 %7159, 2147483647, !dbg !1113
  %is_zero1720 = icmp eq i32 %7160, 0, !dbg !1113
  %7161 = bitcast float %6990 to i32, !dbg !1113
  %7162 = and i32 %7161, 2147483647, !dbg !1113
  %is_zero1721 = icmp eq i32 %7162, 0, !dbg !1113
  %7163 = xor i1 %is_zero1721, true, !dbg !1113
  %7164 = bitcast float %6016 to i32, !dbg !1113
  %7165 = and i32 %7164, 2147483647, !dbg !1113
  %is_zero1722 = icmp eq i32 %7165, 0, !dbg !1113
  %7166 = xor i1 %is_zero1722, true, !dbg !1113
  %7167 = bitcast float %6016 to i32, !dbg !1113
  %7168 = and i32 %7167, 2147483647, !dbg !1113
  %is_zero1723 = icmp eq i32 %7168, 0, !dbg !1113
  %7169 = xor i1 %is_zero1723, true, !dbg !1113
  %7170 = and i1 %7163, %7166, !dbg !1113
  %7171 = and i1 %7170, %7169, !dbg !1113
  %7172 = and i1 %is_zero1720, %7171, !dbg !1113
  %is_tiny1724 = or i1 %is_subnormal1719, %7172, !dbg !1113
  %underflow_cond1725 = and i1 %7153, %is_tiny1724, !dbg !1113
  br i1 %underflow_cond1725, label %7173, label %7175, !dbg !1113

7173:                                             ; preds = %7132
  %7174 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %7175, !dbg !1113

7175:                                             ; preds = %7132, %7173
  %7176 = bitcast float %6990 to i32, !dbg !1113
  %7177 = and i32 %7176, 2139095040, !dbg !1113
  %7178 = icmp eq i32 %7177, 0, !dbg !1113
  %7179 = and i32 %7176, 8388607, !dbg !1113
  %7180 = icmp ne i32 %7179, 0, !dbg !1113
  %is_subnormal1726 = and i1 %7178, %7180, !dbg !1113
  %7181 = xor i1 %is_subnormal1726, true, !dbg !1113
  %7182 = and i1 true, %7181, !dbg !1113
  %7183 = bitcast float %6016 to i32, !dbg !1113
  %7184 = and i32 %7183, 2139095040, !dbg !1113
  %7185 = icmp eq i32 %7184, 0, !dbg !1113
  %7186 = and i32 %7183, 8388607, !dbg !1113
  %7187 = icmp ne i32 %7186, 0, !dbg !1113
  %is_subnormal1727 = and i1 %7185, %7187, !dbg !1113
  %7188 = xor i1 %is_subnormal1727, true, !dbg !1113
  %7189 = and i1 %7182, %7188, !dbg !1113
  %7190 = bitcast float %6016 to i32, !dbg !1113
  %7191 = and i32 %7190, 2139095040, !dbg !1113
  %7192 = icmp eq i32 %7191, 0, !dbg !1113
  %7193 = and i32 %7190, 8388607, !dbg !1113
  %7194 = icmp ne i32 %7193, 0, !dbg !1113
  %is_subnormal1728 = and i1 %7192, %7194, !dbg !1113
  %7195 = xor i1 %is_subnormal1728, true, !dbg !1113
  %7196 = and i1 %7189, %7195, !dbg !1113
  %7197 = bitcast float %7112 to i32, !dbg !1113
  %7198 = and i32 %7197, 2139095040, !dbg !1113
  %7199 = icmp eq i32 %7198, 0, !dbg !1113
  %7200 = and i32 %7197, 8388607, !dbg !1113
  %7201 = icmp ne i32 %7200, 0, !dbg !1113
  %is_subnormal1729 = and i1 %7199, %7201, !dbg !1113
  %subnormal_cond1730 = and i1 %7196, %is_subnormal1729, !dbg !1113
  br i1 %subnormal_cond1730, label %7202, label %7204, !dbg !1113

7202:                                             ; preds = %7175
  %7203 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %7204, !dbg !1113

7204:                                             ; preds = %7175, %7202
  %7205 = bitcast float %5917 to i32, !dbg !1113
  %7206 = bitcast float %5917 to i32, !dbg !1113
  %7207 = and i32 %7206, 2139095040, !dbg !1113
  %7208 = icmp eq i32 %7207, 2139095040, !dbg !1113
  %7209 = and i32 %7206, 8388607, !dbg !1113
  %7210 = icmp ne i32 %7209, 0, !dbg !1113
  %is_nan1731 = and i1 %7208, %7210, !dbg !1113
  %7211 = and i32 %7205, 4194304, !dbg !1113
  %7212 = icmp eq i32 %7211, 0, !dbg !1113
  %is_snan1732 = and i1 %is_nan1731, %7212, !dbg !1113
  %7213 = or i1 %is_snan1732, false, !dbg !1113
  %7214 = bitcast float %7112 to i32, !dbg !1113
  %7215 = bitcast float %7112 to i32, !dbg !1113
  %7216 = and i32 %7215, 2139095040, !dbg !1113
  %7217 = icmp eq i32 %7216, 2139095040, !dbg !1113
  %7218 = and i32 %7215, 8388607, !dbg !1113
  %7219 = icmp ne i32 %7218, 0, !dbg !1113
  %is_nan1733 = and i1 %7217, %7219, !dbg !1113
  %7220 = and i32 %7214, 4194304, !dbg !1113
  %7221 = icmp eq i32 %7220, 0, !dbg !1113
  %is_snan1734 = and i1 %is_nan1733, %7221, !dbg !1113
  %7222 = or i1 %7213, %is_snan1734, !dbg !1113
  %7223 = bitcast float %5917 to i32, !dbg !1113
  %7224 = and i32 %7223, 2147483647, !dbg !1113
  %is_zero1735 = icmp eq i32 %7224, 0, !dbg !1113
  %7225 = and i1 %is_zero1735, false, !dbg !1113
  %7226 = bitcast float %5917 to i32, !dbg !1113
  %7227 = and i32 %7226, 2139095040, !dbg !1113
  %7228 = icmp eq i32 %7227, 2139095040, !dbg !1113
  %7229 = and i32 %7226, 8388607, !dbg !1113
  %7230 = icmp eq i32 %7229, 0, !dbg !1113
  %is_inf1736 = and i1 %7228, %7230, !dbg !1113
  %7231 = and i1 %is_inf1736, false, !dbg !1113
  %7232 = or i1 %7225, %7231, !dbg !1113
  %7233 = or i1 %7222, %7232, !dbg !1113
  br i1 %7233, label %7234, label %7236, !dbg !1113

7234:                                             ; preds = %7204
  %7235 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %7236, !dbg !1113

7236:                                             ; preds = %7204, %7234
  %7237 = call float @llvm.nvvm.fma.rn.f(float %5917, float 0x3FE62E4300000000, float %7112) #5, !dbg !1113
  %7238 = bitcast float %5917 to i32, !dbg !1113
  %7239 = and i32 %7238, 2139095040, !dbg !1113
  %is_finite1737 = icmp ne i32 %7239, 2139095040, !dbg !1113
  %7240 = and i1 true, %is_finite1737, !dbg !1113
  %7241 = and i1 %7240, true, !dbg !1113
  %7242 = bitcast float %7237 to i32, !dbg !1113
  %7243 = and i32 %7242, 2139095040, !dbg !1113
  %7244 = icmp eq i32 %7243, 2139095040, !dbg !1113
  %7245 = and i32 %7242, 8388607, !dbg !1113
  %7246 = icmp eq i32 %7245, 0, !dbg !1113
  %is_inf1738 = and i1 %7244, %7246, !dbg !1113
  %7247 = bitcast float %7237 to i32, !dbg !1113
  %7248 = and i32 %7247, 2147483647, !dbg !1113
  %is_maxfinite1739 = icmp eq i32 %7248, 2139095039, !dbg !1113
  %7249 = bitcast float %7237 to i32, !dbg !1113
  %7250 = and i32 %7249, -2147483648, !dbg !1113
  %7251 = icmp eq i32 %7250, 0, !dbg !1113
  %7252 = icmp ne i32 %7250, 0, !dbg !1113
  %is_pos_inf1740 = and i1 %is_inf1738, %7251, !dbg !1113
  %is_neg_inf1741 = and i1 %is_inf1738, %7252, !dbg !1113
  %is_pos_max1742 = and i1 %is_maxfinite1739, %7251, !dbg !1113
  %is_neg_max1743 = and i1 %is_maxfinite1739, %7252, !dbg !1113
  %overflow_cond1744 = and i1 %7241, %is_inf1738, !dbg !1113
  br i1 %overflow_cond1744, label %7253, label %7255, !dbg !1113

7253:                                             ; preds = %7236
  %7254 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %7255, !dbg !1113

7255:                                             ; preds = %7236, %7253
  %7256 = bitcast float %5917 to i32, !dbg !1113
  %7257 = and i32 %7256, 2139095040, !dbg !1113
  %7258 = icmp eq i32 %7257, 0, !dbg !1113
  %7259 = and i32 %7256, 8388607, !dbg !1113
  %7260 = icmp ne i32 %7259, 0, !dbg !1113
  %is_subnormal1745 = and i1 %7258, %7260, !dbg !1113
  %7261 = xor i1 %is_subnormal1745, true, !dbg !1113
  %7262 = and i1 true, %7261, !dbg !1113
  %7263 = and i1 %7262, true, !dbg !1113
  %7264 = bitcast float %7112 to i32, !dbg !1113
  %7265 = and i32 %7264, 2139095040, !dbg !1113
  %7266 = icmp eq i32 %7265, 0, !dbg !1113
  %7267 = and i32 %7264, 8388607, !dbg !1113
  %7268 = icmp ne i32 %7267, 0, !dbg !1113
  %is_subnormal1746 = and i1 %7266, %7268, !dbg !1113
  %7269 = xor i1 %is_subnormal1746, true, !dbg !1113
  %7270 = and i1 %7263, %7269, !dbg !1113
  %7271 = bitcast float %7237 to i32, !dbg !1113
  %7272 = and i32 %7271, 2139095040, !dbg !1113
  %7273 = icmp eq i32 %7272, 0, !dbg !1113
  %7274 = and i32 %7271, 8388607, !dbg !1113
  %7275 = icmp ne i32 %7274, 0, !dbg !1113
  %is_subnormal1747 = and i1 %7273, %7275, !dbg !1113
  %7276 = bitcast float %7237 to i32, !dbg !1113
  %7277 = and i32 %7276, 2147483647, !dbg !1113
  %is_zero1748 = icmp eq i32 %7277, 0, !dbg !1113
  %7278 = bitcast float %5917 to i32, !dbg !1113
  %7279 = and i32 %7278, 2147483647, !dbg !1113
  %is_zero1749 = icmp eq i32 %7279, 0, !dbg !1113
  %7280 = xor i1 %is_zero1749, true, !dbg !1113
  %7281 = bitcast float %7112 to i32, !dbg !1113
  %7282 = and i32 %7281, 2147483647, !dbg !1113
  %is_zero1750 = icmp eq i32 %7282, 0, !dbg !1113
  %7283 = xor i1 %is_zero1750, true, !dbg !1113
  %7284 = and i1 %7280, true, !dbg !1113
  %7285 = and i1 %7284, %7283, !dbg !1113
  %7286 = and i1 %is_zero1748, %7285, !dbg !1113
  %is_tiny1751 = or i1 %is_subnormal1747, %7286, !dbg !1113
  %underflow_cond1752 = and i1 %7270, %is_tiny1751, !dbg !1113
  br i1 %underflow_cond1752, label %7287, label %7289, !dbg !1113

7287:                                             ; preds = %7255
  %7288 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %7289, !dbg !1113

7289:                                             ; preds = %7255, %7287
  %7290 = bitcast float %5917 to i32, !dbg !1113
  %7291 = and i32 %7290, 2139095040, !dbg !1113
  %7292 = icmp eq i32 %7291, 0, !dbg !1113
  %7293 = and i32 %7290, 8388607, !dbg !1113
  %7294 = icmp ne i32 %7293, 0, !dbg !1113
  %is_subnormal1753 = and i1 %7292, %7294, !dbg !1113
  %7295 = xor i1 %is_subnormal1753, true, !dbg !1113
  %7296 = and i1 true, %7295, !dbg !1113
  %7297 = and i1 %7296, true, !dbg !1113
  %7298 = bitcast float %7112 to i32, !dbg !1113
  %7299 = and i32 %7298, 2139095040, !dbg !1113
  %7300 = icmp eq i32 %7299, 0, !dbg !1113
  %7301 = and i32 %7298, 8388607, !dbg !1113
  %7302 = icmp ne i32 %7301, 0, !dbg !1113
  %is_subnormal1754 = and i1 %7300, %7302, !dbg !1113
  %7303 = xor i1 %is_subnormal1754, true, !dbg !1113
  %7304 = and i1 %7297, %7303, !dbg !1113
  %7305 = bitcast float %7237 to i32, !dbg !1113
  %7306 = and i32 %7305, 2139095040, !dbg !1113
  %7307 = icmp eq i32 %7306, 0, !dbg !1113
  %7308 = and i32 %7305, 8388607, !dbg !1113
  %7309 = icmp ne i32 %7308, 0, !dbg !1113
  %is_subnormal1755 = and i1 %7307, %7309, !dbg !1113
  %subnormal_cond1756 = and i1 %7304, %is_subnormal1755, !dbg !1113
  br i1 %subnormal_cond1756, label %7310, label %7312, !dbg !1113

7310:                                             ; preds = %7289
  %7311 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %7312, !dbg !1113

7312:                                             ; preds = %7289, %7310
  %7313 = bitcast float %.02.i to i32, !dbg !1113
  %7314 = icmp uge i32 %7313, 2139095040, !dbg !1113
  br i1 %7314, label %7315, label %7401, !dbg !1113

7315:                                             ; preds = %7312
  %7316 = bitcast float %.02.i to i32, !dbg !1113
  %7317 = bitcast float %.02.i to i32, !dbg !1113
  %7318 = and i32 %7317, 2139095040, !dbg !1113
  %7319 = icmp eq i32 %7318, 2139095040, !dbg !1113
  %7320 = and i32 %7317, 8388607, !dbg !1113
  %7321 = icmp ne i32 %7320, 0, !dbg !1113
  %is_nan1757 = and i1 %7319, %7321, !dbg !1113
  %7322 = and i32 %7316, 4194304, !dbg !1113
  %7323 = icmp eq i32 %7322, 0, !dbg !1113
  %is_snan1758 = and i1 %is_nan1757, %7323, !dbg !1113
  %7324 = or i1 %is_snan1758, false, !dbg !1113
  %7325 = or i1 %7324, false, !dbg !1113
  %7326 = bitcast float %.02.i to i32, !dbg !1113
  %7327 = and i32 %7326, 2147483647, !dbg !1113
  %is_zero1759 = icmp eq i32 %7327, 0, !dbg !1113
  %7328 = and i1 %is_zero1759, true, !dbg !1113
  %7329 = bitcast float %.02.i to i32, !dbg !1113
  %7330 = and i32 %7329, 2139095040, !dbg !1113
  %7331 = icmp eq i32 %7330, 2139095040, !dbg !1113
  %7332 = and i32 %7329, 8388607, !dbg !1113
  %7333 = icmp eq i32 %7332, 0, !dbg !1113
  %is_inf1760 = and i1 %7331, %7333, !dbg !1113
  %7334 = and i1 %is_inf1760, false, !dbg !1113
  %7335 = or i1 %7328, %7334, !dbg !1113
  %7336 = or i1 %7325, %7335, !dbg !1113
  br i1 %7336, label %7337, label %7339, !dbg !1113

7337:                                             ; preds = %7315
  %7338 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1113
  br label %7339, !dbg !1113

7339:                                             ; preds = %7315, %7337
  %7340 = call float @llvm.nvvm.fma.rn.f(float %.02.i, float 0x7FF0000000000000, float 0x7FF0000000000000) #5, !dbg !1113
  %7341 = bitcast float %.02.i to i32, !dbg !1113
  %7342 = and i32 %7341, 2139095040, !dbg !1113
  %is_finite1761 = icmp ne i32 %7342, 2139095040, !dbg !1113
  %7343 = and i1 true, %is_finite1761, !dbg !1113
  %7344 = and i1 %7343, false, !dbg !1113
  %7345 = bitcast float %7340 to i32, !dbg !1113
  %7346 = and i32 %7345, 2139095040, !dbg !1113
  %7347 = icmp eq i32 %7346, 2139095040, !dbg !1113
  %7348 = and i32 %7345, 8388607, !dbg !1113
  %7349 = icmp eq i32 %7348, 0, !dbg !1113
  %is_inf1762 = and i1 %7347, %7349, !dbg !1113
  %7350 = bitcast float %7340 to i32, !dbg !1113
  %7351 = and i32 %7350, 2147483647, !dbg !1113
  %is_maxfinite1763 = icmp eq i32 %7351, 2139095039, !dbg !1113
  %7352 = bitcast float %7340 to i32, !dbg !1113
  %7353 = and i32 %7352, -2147483648, !dbg !1113
  %7354 = icmp eq i32 %7353, 0, !dbg !1113
  %7355 = icmp ne i32 %7353, 0, !dbg !1113
  %is_pos_inf1764 = and i1 %is_inf1762, %7354, !dbg !1113
  %is_neg_inf1765 = and i1 %is_inf1762, %7355, !dbg !1113
  %is_pos_max1766 = and i1 %is_maxfinite1763, %7354, !dbg !1113
  %is_neg_max1767 = and i1 %is_maxfinite1763, %7355, !dbg !1113
  %overflow_cond1768 = and i1 %7344, %is_inf1762, !dbg !1113
  br i1 %overflow_cond1768, label %7356, label %7358, !dbg !1113

7356:                                             ; preds = %7339
  %7357 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1113
  br label %7358, !dbg !1113

7358:                                             ; preds = %7339, %7356
  %7359 = bitcast float %.02.i to i32, !dbg !1113
  %7360 = and i32 %7359, 2139095040, !dbg !1113
  %7361 = icmp eq i32 %7360, 0, !dbg !1113
  %7362 = and i32 %7359, 8388607, !dbg !1113
  %7363 = icmp ne i32 %7362, 0, !dbg !1113
  %is_subnormal1769 = and i1 %7361, %7363, !dbg !1113
  %7364 = xor i1 %is_subnormal1769, true, !dbg !1113
  %7365 = and i1 true, %7364, !dbg !1113
  %7366 = and i1 %7365, true, !dbg !1113
  %7367 = and i1 %7366, true, !dbg !1113
  %7368 = bitcast float %7340 to i32, !dbg !1113
  %7369 = and i32 %7368, 2139095040, !dbg !1113
  %7370 = icmp eq i32 %7369, 0, !dbg !1113
  %7371 = and i32 %7368, 8388607, !dbg !1113
  %7372 = icmp ne i32 %7371, 0, !dbg !1113
  %is_subnormal1770 = and i1 %7370, %7372, !dbg !1113
  %7373 = bitcast float %7340 to i32, !dbg !1113
  %7374 = and i32 %7373, 2147483647, !dbg !1113
  %is_zero1771 = icmp eq i32 %7374, 0, !dbg !1113
  %7375 = bitcast float %.02.i to i32, !dbg !1113
  %7376 = and i32 %7375, 2147483647, !dbg !1113
  %is_zero1772 = icmp eq i32 %7376, 0, !dbg !1113
  %7377 = xor i1 %is_zero1772, true, !dbg !1113
  %7378 = and i1 %7377, true, !dbg !1113
  %7379 = and i1 %7378, true, !dbg !1113
  %7380 = and i1 %is_zero1771, %7379, !dbg !1113
  %is_tiny1773 = or i1 %is_subnormal1770, %7380, !dbg !1113
  %underflow_cond1774 = and i1 %7367, %is_tiny1773, !dbg !1113
  br i1 %underflow_cond1774, label %7381, label %7383, !dbg !1113

7381:                                             ; preds = %7358
  %7382 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1113
  br label %7383, !dbg !1113

7383:                                             ; preds = %7358, %7381
  %7384 = bitcast float %.02.i to i32, !dbg !1113
  %7385 = and i32 %7384, 2139095040, !dbg !1113
  %7386 = icmp eq i32 %7385, 0, !dbg !1113
  %7387 = and i32 %7384, 8388607, !dbg !1113
  %7388 = icmp ne i32 %7387, 0, !dbg !1113
  %is_subnormal1775 = and i1 %7386, %7388, !dbg !1113
  %7389 = xor i1 %is_subnormal1775, true, !dbg !1113
  %7390 = and i1 true, %7389, !dbg !1113
  %7391 = and i1 %7390, true, !dbg !1113
  %7392 = and i1 %7391, true, !dbg !1113
  %7393 = bitcast float %7340 to i32, !dbg !1113
  %7394 = and i32 %7393, 2139095040, !dbg !1113
  %7395 = icmp eq i32 %7394, 0, !dbg !1113
  %7396 = and i32 %7393, 8388607, !dbg !1113
  %7397 = icmp ne i32 %7396, 0, !dbg !1113
  %is_subnormal1776 = and i1 %7395, %7397, !dbg !1113
  %subnormal_cond1777 = and i1 %7392, %is_subnormal1776, !dbg !1113
  br i1 %subnormal_cond1777, label %7398, label %7400, !dbg !1113

7398:                                             ; preds = %7383
  %7399 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1113
  br label %7400, !dbg !1113

7400:                                             ; preds = %7383, %7398
  br label %7401, !dbg !1113

7401:                                             ; preds = %7400, %7312
  %r.i.0.i = phi float [ %7340, %7400 ], [ %7237, %7312 ], !dbg !1113
  %7402 = fcmp oeq float %.02.i, 0.000000e+00, !dbg !1113
  br i1 %7402, label %7403, label %__nv_logf.exit, !dbg !1113

7403:                                             ; preds = %7401
  br label %__nv_logf.exit, !dbg !1113

__nv_logf.exit:                                   ; preds = %7401, %7403
  %r.i.1.i = phi float [ 0xFFF0000000000000, %7403 ], [ %r.i.0.i, %7401 ], !dbg !1113
  %7404 = load ptr, ptr %result.addr, align 8, !dbg !1114
  %arrayidx58 = getelementptr inbounds float, ptr %7404, i64 7, !dbg !1114
  store float %r.i.1.i, ptr %arrayidx58, align 4, !dbg !1115
  %7405 = load ptr, ptr %result.addr, align 8, !dbg !1116
  %arrayidx59 = getelementptr inbounds float, ptr %7405, i64 7, !dbg !1116
  %7406 = load float, ptr %arrayidx59, align 4, !dbg !1116
  %call60 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %7406) #4, !dbg !1117
  %7407 = zext i1 %call60 to i64, !dbg !1117
  %cond61 = select i1 %call60, i32 1, i32 0, !dbg !1117
  %7408 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1118
  %arrayidx62 = getelementptr inbounds i32, ptr %7408, i64 7, !dbg !1118
  store i32 %cond61, ptr %arrayidx62, align 4, !dbg !1119
  br label %if.end63, !dbg !1120

if.end63:                                         ; preds = %__nv_logf.exit, %if.end54
  ret void, !dbg !1121
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.sqrt.approx.f(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.saturate.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rm.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.ex2.approx.ftz.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.trunc.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.add.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.round.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.floor.f(float) #1

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { convergent nounwind }
attributes #5 = { nounwind }
attributes #6 = { nounwind memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!954, !955}
!nvvmir.version = !{!956}
!llvm.module.flags = !{!957, !958, !959, !960, !961, !962}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/underflow/basic.cu", directory: "/home/users/sislam3/SBAC-PAD")
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
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !295, !297, !299, !303, !305, !307, !309, !311, !313, !315, !317, !321, !325, !327, !329, !334, !336, !338, !340, !342, !344, !346, !349, !351, !353, !355, !360, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !386, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !420, !422, !426, !428, !430, !432, !434, !436, !438, !440, !442, !444, !448, !450, !454, !456, !458, !460, !464, !466, !470, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !498, !500, !504, !506, !508, !510, !512, !514, !518, !520, !522, !524, !526, !528, !530, !534, !538, !540, !542, !544, !546, !550, !552, !556, !558, !560, !562, !564, !566, !568, !572, !574, !578, !580, !582, !586, !588, !590, !592, !594, !596, !598, !602, !606, !612, !616, !624, !629, !631, !633, !637, !641, !651, !653, !657, !661, !665, !670, !672, !676, !680, !684, !692, !696, !700, !702, !706, !710, !714, !720, !724, !728, !730, !738, !742, !749, !751, !753, !757, !761, !765, !769, !773, !777, !778, !779, !780, !782, !783, !784, !785, !786, !787, !788, !790, !791, !792, !793, !794, !795, !796, !797, !802, !803, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !830, !832, !834, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !861, !863, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945, !947, !949}
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
!859 = distinct !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !828, file: !828, line: 113, type: !101, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!860 = !{}
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !862, file: !829, line: 459)
!862 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !828, file: !828, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !864, file: !829, line: 460)
!864 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !828, file: !828, line: 116, type: !101, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
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
!900 = distinct !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !828, file: !828, line: 186, type: !101, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
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
!912 = distinct !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !828, file: !828, line: 235, type: !114, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
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
!930 = distinct !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !828, file: !828, line: 318, type: !101, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
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
!963 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !1, file: !1, line: 6, type: !169, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!964 = !DILocalVariable(name: "x", arg: 1, scope: !963, file: !1, line: 6, type: !103)
!965 = !DILocation(line: 6, column: 36, scope: !963)
!966 = !DILocation(line: 7, column: 13, scope: !963)
!967 = !DILocation(line: 7, column: 15, scope: !963)
!968 = !DILocation(line: 7, column: 24, scope: !963)
!969 = !DILocation(line: 7, column: 34, scope: !963)
!970 = !DILocalVariable(name: "__a", arg: 1, scope: !864, file: !828, line: 116, type: !103)
!971 = !DILocation(line: 116, column: 30, scope: !864, inlinedAt: !972)
!972 = distinct !DILocation(line: 7, column: 28, scope: !963)
!973 = !DILocation(line: 116, column: 55, scope: !864, inlinedAt: !972)
!974 = !DILocation(line: 116, column: 44, scope: !864, inlinedAt: !972)
!975 = !DILocation(line: 7, column: 37, scope: !963)
!976 = !DILocation(line: 0, scope: !963)
!977 = !DILocation(line: 7, column: 5, scope: !963)
!978 = distinct !DISubprogram(name: "testUnderflow_Operations", linkageName: "_Z24testUnderflow_OperationsPfPi", scope: !1, file: !1, line: 10, type: !979, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!979 = !DISubroutineType(types: !980)
!980 = !{null, !234, !162}
!981 = !DILocalVariable(name: "result", arg: 1, scope: !978, file: !1, line: 10, type: !234)
!982 = !DILocation(line: 10, column: 49, scope: !978)
!983 = !DILocalVariable(name: "is_denorm", arg: 2, scope: !978, file: !1, line: 10, type: !162)
!984 = !DILocation(line: 10, column: 62, scope: !978)
!985 = !DILocalVariable(name: "idx", scope: !978, file: !1, line: 11, type: !98)
!986 = !DILocation(line: 11, column: 9, scope: !978)
!987 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!989 = distinct !DILocation(line: 11, column: 15, scope: !978)
!990 = !DILocalVariable(name: "tiny", scope: !978, file: !1, line: 13, type: !103)
!991 = !DILocation(line: 13, column: 11, scope: !978)
!992 = !DILocation(line: 17, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !978, file: !1, line: 17, column: 9)
!994 = !DILocation(line: 17, column: 13, scope: !993)
!995 = !DILocation(line: 19, column: 21, scope: !996)
!996 = distinct !DILexicalBlock(scope: !993, file: !1, line: 17, column: 19)
!997 = !DILocation(line: 19, column: 26, scope: !996)
!998 = !DILocation(line: 19, column: 9, scope: !996)
!999 = !DILocation(line: 19, column: 19, scope: !996)
!1000 = !DILocation(line: 20, column: 37, scope: !996)
!1001 = !DILocation(line: 20, column: 24, scope: !996)
!1002 = !DILocation(line: 20, column: 9, scope: !996)
!1003 = !DILocation(line: 20, column: 22, scope: !996)
!1004 = !DILocation(line: 21, column: 5, scope: !996)
!1005 = !DILocation(line: 23, column: 9, scope: !1006)
!1006 = distinct !DILexicalBlock(scope: !978, file: !1, line: 23, column: 9)
!1007 = !DILocation(line: 23, column: 13, scope: !1006)
!1008 = !DILocation(line: 25, column: 21, scope: !1009)
!1009 = distinct !DILexicalBlock(scope: !1006, file: !1, line: 23, column: 19)
!1010 = !DILocation(line: 25, column: 26, scope: !1009)
!1011 = !DILocation(line: 25, column: 9, scope: !1009)
!1012 = !DILocation(line: 25, column: 19, scope: !1009)
!1013 = !DILocation(line: 26, column: 37, scope: !1009)
!1014 = !DILocation(line: 26, column: 24, scope: !1009)
!1015 = !DILocation(line: 26, column: 9, scope: !1009)
!1016 = !DILocation(line: 26, column: 22, scope: !1009)
!1017 = !DILocation(line: 27, column: 5, scope: !1009)
!1018 = !DILocation(line: 29, column: 9, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !978, file: !1, line: 29, column: 9)
!1020 = !DILocation(line: 29, column: 13, scope: !1019)
!1021 = !DILocalVariable(name: "a", scope: !1022, file: !1, line: 31, type: !103)
!1022 = distinct !DILexicalBlock(scope: !1019, file: !1, line: 29, column: 19)
!1023 = !DILocation(line: 31, column: 15, scope: !1022)
!1024 = !DILocalVariable(name: "b", scope: !1022, file: !1, line: 32, type: !103)
!1025 = !DILocation(line: 32, column: 15, scope: !1022)
!1026 = !DILocation(line: 33, column: 21, scope: !1022)
!1027 = !DILocation(line: 33, column: 25, scope: !1022)
!1028 = !DILocation(line: 33, column: 23, scope: !1022)
!1029 = !DILocation(line: 33, column: 9, scope: !1022)
!1030 = !DILocation(line: 33, column: 19, scope: !1022)
!1031 = !DILocation(line: 34, column: 37, scope: !1022)
!1032 = !DILocation(line: 34, column: 24, scope: !1022)
!1033 = !DILocation(line: 34, column: 9, scope: !1022)
!1034 = !DILocation(line: 34, column: 22, scope: !1022)
!1035 = !DILocation(line: 35, column: 5, scope: !1022)
!1036 = !DILocation(line: 37, column: 9, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !978, file: !1, line: 37, column: 9)
!1038 = !DILocation(line: 37, column: 13, scope: !1037)
!1039 = !DILocalVariable(name: "denorm", scope: !1040, file: !1, line: 39, type: !103)
!1040 = distinct !DILexicalBlock(scope: !1037, file: !1, line: 37, column: 19)
!1041 = !DILocation(line: 39, column: 15, scope: !1040)
!1042 = !DILocation(line: 40, column: 21, scope: !1040)
!1043 = !DILocation(line: 40, column: 30, scope: !1040)
!1044 = !DILocation(line: 40, column: 28, scope: !1040)
!1045 = !DILocation(line: 40, column: 9, scope: !1040)
!1046 = !DILocation(line: 40, column: 19, scope: !1040)
!1047 = !DILocation(line: 41, column: 37, scope: !1040)
!1048 = !DILocation(line: 41, column: 24, scope: !1040)
!1049 = !DILocation(line: 41, column: 9, scope: !1040)
!1050 = !DILocation(line: 41, column: 22, scope: !1040)
!1051 = !DILocation(line: 42, column: 5, scope: !1040)
!1052 = !DILocation(line: 44, column: 9, scope: !1053)
!1053 = distinct !DILexicalBlock(scope: !978, file: !1, line: 44, column: 9)
!1054 = !DILocation(line: 44, column: 13, scope: !1053)
!1055 = !DILocation(line: 46, column: 27, scope: !1056)
!1056 = distinct !DILexicalBlock(scope: !1053, file: !1, line: 44, column: 19)
!1057 = !DILocalVariable(name: "__a", arg: 1, scope: !930, file: !828, line: 318, type: !103)
!1058 = !DILocation(line: 318, column: 30, scope: !930, inlinedAt: !1059)
!1059 = distinct !DILocation(line: 46, column: 21, scope: !1056)
!1060 = !DILocation(line: 318, column: 55, scope: !930, inlinedAt: !1059)
!1061 = !DILocation(line: 318, column: 44, scope: !930, inlinedAt: !1059)
!1062 = !DILocation(line: 46, column: 9, scope: !1056)
!1063 = !DILocation(line: 46, column: 19, scope: !1056)
!1064 = !DILocation(line: 47, column: 37, scope: !1056)
!1065 = !DILocation(line: 47, column: 24, scope: !1056)
!1066 = !DILocation(line: 47, column: 9, scope: !1056)
!1067 = !DILocation(line: 47, column: 22, scope: !1056)
!1068 = !DILocation(line: 48, column: 5, scope: !1056)
!1069 = !DILocation(line: 50, column: 9, scope: !1070)
!1070 = distinct !DILexicalBlock(scope: !978, file: !1, line: 50, column: 9)
!1071 = !DILocation(line: 50, column: 13, scope: !1070)
!1072 = !DILocalVariable(name: "__a", arg: 1, scope: !859, file: !828, line: 113, type: !103)
!1073 = !DILocation(line: 113, column: 29, scope: !859, inlinedAt: !1074)
!1074 = distinct !DILocation(line: 52, column: 21, scope: !1075)
!1075 = distinct !DILexicalBlock(scope: !1070, file: !1, line: 50, column: 19)
!1076 = !DILocation(line: 113, column: 53, scope: !859, inlinedAt: !1074)
!1077 = !DILocation(line: 113, column: 43, scope: !859, inlinedAt: !1074)
!1078 = !DILocation(line: 52, column: 9, scope: !1075)
!1079 = !DILocation(line: 52, column: 19, scope: !1075)
!1080 = !DILocation(line: 53, column: 37, scope: !1075)
!1081 = !DILocation(line: 53, column: 24, scope: !1075)
!1082 = !DILocation(line: 53, column: 9, scope: !1075)
!1083 = !DILocation(line: 53, column: 22, scope: !1075)
!1084 = !DILocation(line: 54, column: 5, scope: !1075)
!1085 = !DILocation(line: 56, column: 9, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !978, file: !1, line: 56, column: 9)
!1087 = !DILocation(line: 56, column: 13, scope: !1086)
!1088 = !DILocalVariable(name: "__a", arg: 1, scope: !912, file: !828, line: 235, type: !103)
!1089 = !DILocation(line: 235, column: 29, scope: !912, inlinedAt: !1090)
!1090 = distinct !DILocation(line: 58, column: 21, scope: !1091)
!1091 = distinct !DILexicalBlock(scope: !1086, file: !1, line: 56, column: 19)
!1092 = !DILocalVariable(name: "__b", arg: 2, scope: !912, file: !828, line: 235, type: !103)
!1093 = !DILocation(line: 235, column: 40, scope: !912, inlinedAt: !1090)
!1094 = !DILocation(line: 235, column: 64, scope: !912, inlinedAt: !1090)
!1095 = !DILocation(line: 235, column: 69, scope: !912, inlinedAt: !1090)
!1096 = !DILocation(line: 235, column: 54, scope: !912, inlinedAt: !1090)
!1097 = !{i32 21684}
!1098 = !DILocation(line: 58, column: 9, scope: !1091)
!1099 = !DILocation(line: 58, column: 19, scope: !1091)
!1100 = !DILocation(line: 59, column: 37, scope: !1091)
!1101 = !DILocation(line: 59, column: 24, scope: !1091)
!1102 = !DILocation(line: 59, column: 9, scope: !1091)
!1103 = !DILocation(line: 59, column: 22, scope: !1091)
!1104 = !DILocation(line: 60, column: 5, scope: !1091)
!1105 = !DILocation(line: 62, column: 9, scope: !1106)
!1106 = distinct !DILexicalBlock(scope: !978, file: !1, line: 62, column: 9)
!1107 = !DILocation(line: 62, column: 13, scope: !1106)
!1108 = !DILocalVariable(name: "__a", arg: 1, scope: !900, file: !828, line: 186, type: !103)
!1109 = !DILocation(line: 186, column: 29, scope: !900, inlinedAt: !1110)
!1110 = distinct !DILocation(line: 64, column: 21, scope: !1111)
!1111 = distinct !DILexicalBlock(scope: !1106, file: !1, line: 62, column: 19)
!1112 = !DILocation(line: 187, column: 52, scope: !900, inlinedAt: !1110)
!1113 = !DILocation(line: 187, column: 41, scope: !900, inlinedAt: !1110)
!1114 = !DILocation(line: 64, column: 9, scope: !1111)
!1115 = !DILocation(line: 64, column: 19, scope: !1111)
!1116 = !DILocation(line: 65, column: 37, scope: !1111)
!1117 = !DILocation(line: 65, column: 24, scope: !1111)
!1118 = !DILocation(line: 65, column: 9, scope: !1111)
!1119 = !DILocation(line: 65, column: 22, scope: !1111)
!1120 = !DILocation(line: 66, column: 5, scope: !1111)
!1121 = !DILocation(line: 67, column: 1, scope: !978)
