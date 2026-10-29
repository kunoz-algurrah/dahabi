<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>نظام إدخال بيانات الوردية</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts (Cairo) -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800&display=swap" rel="stylesheet">
    <!-- Supabase JS Client -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <style>
        body {
            font-family: 'Cairo', sans-serif;
            background-color: #f1f5f9;
        }
    </style>
</head>
<body class="text-slate-800 antialiased min-h-screen p-3 md:p-6">

    <div class="max-w-7xl mx-auto space-y-6">
        <!-- Header -->
        <header class="bg-gradient-to-r from-amber-600 via-amber-700 to-yellow-600 text-white rounded-2xl p-6 shadow-xl flex flex-col md:flex-row justify-between items-center gap-4">
            <div class="flex items-center gap-4">
                <div class="bg-white/10 p-4 rounded-xl backdrop-blur-sm border border-white/20">
                    <i class="fa-solid font-bold fa-fill-drip text-3xl text-amber-300"></i>
                </div>
                <div>
                    <h1 class="text-2xl md:text-3xl font-extrabold tracking-wide">نظام إدارة بيانات الورديات</h1>
                    <p class="text-amber-100 text-sm mt-1">تعدين وآبار - نموذج إدخال وحسابات العود والوردية</p>
                </div>
            </div>
            <div class="flex items-center gap-2 bg-black/20 px-4 py-2 rounded-lg text-xs md:text-sm border border-white/10">
                <i class="fa-solid fa-database text-green-400"></i>
                <span>متصل بقاعدة البيانات</span>
            </div>
        </header>

        <!-- Main Grid Container -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- Entry Form Section (7 cols on large screens) -->
            <section class="lg:col-span-7 bg-white rounded-2xl shadow-md border border-slate-200/80 p-5 md:p-7">
                <div class="flex items-center justify-between pb-4 mb-6 border-b border-slate-100">
                    <h2 class="text-xl font-bold text-slate-800 flex items-center gap-2">
                        <i class="fa-solid fa-pen-to-square text-amber-600"></i>
                        نموذج إدخال الوردية
                    </h2>
                    <button type="button" onclick="resetForm()" class="text-xs text-slate-500 hover:text-slate-700 flex items-center gap-1 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-lg transition-all">
                        <i class="fa-solid fa-rotate-left"></i> تفريغ النموذج
                    </button>
                </div>

                <form id="shiftForm" class="space-y-6">
                    <!-- 1. Basic Info -->
                    <div>
                        <h3 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-3 flex items-center gap-2 border-r-4 border-amber-500 pr-2">
                            البيانات الأساسية
                        </h3>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">اسم البئر <span class="text-red-500">*</span></label>
                                <input type="text" id="well_name" required placeholder="أدخل اسم البئر"
                                    class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">رقم الوردية <span class="text-red-500">*</span></label>
                                <input type="number" id="shift_number" required placeholder="0" value="1" min="1"
                                    class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">رئيس الكلة</label>
                                <input type="text" id="head_of_kulah" placeholder="اسم رئيس الكلة"
                                    class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition-all">
                            </div>
                        </div>
                    </div>

                    <!-- 2. Financial & Quantities -->
                    <div>
                        <h3 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-3 flex items-center gap-2 border-r-4 border-blue-500 pr-2">
                            الكميات والماليات والتكاليف
                        </h3>
                        <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">العدد (Count)</label>
                                <input type="number" step="any" id="count_val" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">المبلغ العائد</label>
                                <input type="number" step="any" id="return_amount" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">ترحيل</label>
                                <input type="number" step="any" id="transfer" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">سحانة</label>
                                <input type="number" step="any" id="sahana" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">فرق زئبق</label>
                                <input type="number" step="any" id="mercury_diff" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">كويجينة</label>
                                <input type="number" step="any" id="kuwijina" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">جرارات</label>
                                <input type="number" step="any" id="tractors" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1">موية</label>
                                <input type="number" step="any" id="water" value="0" onclick="this.select()"
                                    class="num-input w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-600 mb-1 text-red-600">الخسائر</label>
                                <input type="number" step="any" id="losses" value="0" onclick="this.select()"
                                    class="num-input w-full bg-red-50 border border-red-200 rounded-lg px-3 py-2 text-sm text-red-700 font-bold focus:outline-none focus:ring-2 focus:ring-red-500 focus:bg-white">
                            </div>
                        </div>
                    </div>

                    <!-- 3. Returns (جدول العود) -->
                    <div>
                        <h3 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-3 flex items-center gap-2 border-r-4 border-emerald-500 pr-2">
                            تفاصيل وحصص العود
                        </h3>
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 bg-emerald-50/50 p-3.5 rounded-xl border border-emerald-100">
                            <div>
                                <label class="block text-xs font-semibold text-emerald-900 mb-1">عود عامل</label>
                                <input type="number" step="any" id="return_worker" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-emerald-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-emerald-900 mb-1">عود مستثمر</label>
                                <input type="number" step="any" id="return_investor" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-emerald-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-emerald-900 mb-1">عود مالك بئر</label>
                                <input type="number" step="any" id="return_well_owner" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-emerald-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-emerald-900 mb-1">عود مسير</label>
                                <input type="number" step="any" id="return_manager" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-emerald-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-700 mb-1">عود ١</label>
                                <input type="number" step="any" id="return_1" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-700 mb-1">عود ٢</label>
                                <input type="number" step="any" id="return_2" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-700 mb-1">عود ٣</label>
                                <input type="number" step="any" id="return_3" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-700 mb-1">عود ٤ (عو٤)</label>
                                <input type="number" step="any" id="return_4" value="0" onclick="this.select()"
                                    class="num-input w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500">
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn"
                        class="w-full bg-amber-600 hover:bg-amber-700 text-white font-bold py-3.5 px-6 rounded-xl shadow-lg hover:shadow-amber-600/30 transition-all flex items-center justify-center gap-2 text-base">
                        <i class="fa-solid fa-cloud-arrow-up text-lg"></i>
                        <span>حفظ وإرسال بيانات الوردية</span>
                    </button>
                </form>
            </section>

            <!-- Table & Overview Section (5 cols on large screens) -->
            <section class="lg:col-span-5 flex flex-col gap-6">
                <!-- Search & Actions -->
                <div class="bg-white rounded-2xl shadow-md border border-slate-200/80 p-5">
                    <div class="flex items-center justify-between mb-3">
                        <h3 class="font-bold text-slate-800 flex items-center gap-2">
                            <i class="fa-solid fa-list-check text-amber-600"></i>
                            الورديات المسجلة مؤخراً
                        </h3>
                        <button onclick="fetchShifts()" class="text-xs text-amber-600 hover:text-amber-800 font-bold flex items-center gap-1">
                            <i class="fa-solid fa-arrows-rotate"></i> تحديث
                        </button>
                    </div>
                    <div class="relative">
                        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="بحث باسم البئر أو رئيس الكلة..."
                            class="w-full bg-slate-50 border border-slate-200 rounded-lg pl-3 pr-9 py-2 text-xs focus:outline-none focus:ring-2 focus:ring-amber-500">
                        <i class="fa-solid fa-magnifying-glass absolute right-3 top-2.5 text-slate-400 text-xs"></i>
                    </div>
                </div>

                <!-- Data Table Container -->
                <div class="bg-white rounded-2xl shadow-md border border-slate-200/80 overflow-hidden flex-1 flex flex-col min-h-[400px]">
                    <div class="overflow-x-auto flex-1 max-h-[550px]">
                        <table class="w-full text-right text-xs">
                            <thead class="bg-slate-100 text-slate-600 font-bold sticky top-0 border-b border-slate-200">
                                <tr>
                                    <th class="p-3">البئر / الوردية</th>
                                    <th class="p-3">رئيس الكلة</th>
                                    <th class="p-3">إجمالي العود</th>
                                    <th class="p-3">الخسائر</th>
                                    <th class="p-3 text-center">الإجراء</th>
                                </tr>
                            </thead>
                            <tbody id="shiftsTableBody" class="divide-y divide-slate-100">
                                <!-- Dynamic Content -->
                                <tr>
                                    <td colspan="5" class="text-center p-8 text-slate-400">
                                        <i class="fa-solid fa-spinner fa-spin text-2xl text-amber-500 mb-2"></i>
                                        <p>جاري تحميل البيانات...</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-3 bg-slate-50 border-t border-slate-100 text-xs text-slate-500 text-center" id="recordCount">
                        إجمالي السجلات: 0
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- Notification Toast -->
    <div id="toast" class="fixed bottom-5 left-5 transform -translate-x-full transition-all duration-300 z-50 flex items-center gap-3 bg-slate-900 text-white px-5 py-3.5 rounded-xl shadow-2xl opacity-0">
        <i id="toastIcon" class="fa-solid fa-circle-check text-emerald-400 text-xl"></i>
        <div>
            <h4 id="toastTitle" class="font-bold text-sm">تمت العملية</h4>
            <p id="toastMessage" class="text-xs text-slate-300">تم حفظ البيانات بنجاح</p>
        </div>
    </div>

    <!-- Application Script -->
    <script>
        // Supabase Initialization
        const SUPABASE_URL = 'https://calwkoyizanyxxgoukhd.supabase.co';
        const SUPABASE_KEY = 'sb_publishable_D8QW6eU9BH0_Lu3Y3CSZLw_A0m5EI0z';
        const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

        let allShiftsData = [];

        // Element Selectors
        const shiftForm = document.getElementById('shiftForm');
        const submitBtn = document.getElementById('submitBtn');
        const tableBody = document.getElementById('shiftsTableBody');
        const recordCount = document.getElementById('recordCount');

        // Numeric fields list for quick handling
        const numericFields = [
            'count_val', 'return_amount', 'transfer', 'sahana', 
            'mercury_diff', 'kuwijina', 'tractors', 'water', 
            'return_worker', 'return_investor', 'return_well_owner', 
            'return_manager', 'return_1', 'return_2', 'return_3', 
            'return_4', 'losses'
        ];

        // Initialize App
        document.addEventListener('DOMContentLoaded', () => {
            fetchShifts();
            
            // Set default 0 on empty blur
            numericFields.forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('blur', (e) => {
                        if (e.target.value === '' || isNaN(e.target.value)) {
                            e
