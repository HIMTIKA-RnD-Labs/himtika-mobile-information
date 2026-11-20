CREATE TABLE IF NOT EXISTS public.himtika_kabinet (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_kabinet TEXT NOT NULL,
    tagline TEXT,
    deskripsi TEXT,
    logo_url TEXT,
    periode VARCHAR(20) NOT NULL, -- Contoh: "2024/2025"
    is_active BOOLEAN DEFAULT true,
    nilai_kabinet JSONB DEFAULT '[]'::jsonb, -- Array object [{title: "...", description: "..."}]
    makna_logo JSONB DEFAULT '[]'::jsonb, -- Array object [{icon: "...", title: "...", description: "..."}]
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Migration jika tabel sudah ada sebelumnya:
ALTER TABLE public.himtika_kabinet ADD COLUMN IF NOT EXISTS nilai_kabinet JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.himtika_kabinet ADD COLUMN IF NOT EXISTS makna_logo JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.himtika_kabinet ADD COLUMN IF NOT EXISTS warna_nama TEXT;

CREATE TABLE IF NOT EXISTS public.himtika_about (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    visi TEXT NOT NULL,
    misi JSONB NOT NULL DEFAULT '[]'::jsonb, -- Array string poin-poin misi
    sejarah_text TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.himtika_divisi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_divisi TEXT NOT NULL, 
    deskripsi TEXT,
    logo_url TEXT,
    urutan INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.himtika_pengurus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    divisi_id UUID REFERENCES public.himtika_divisi(id) ON DELETE CASCADE,
    nama TEXT NOT NULL,
    jabatan TEXT NOT NULL,
    foto_url TEXT,
    urutan INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.himtika_kabinet ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.himtika_about ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.himtika_divisi ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.himtika_pengurus ENABLE ROW LEVEL SECURITY;

-- Hapus policy lama jika ada agar tidak error "already exists"
DROP POLICY IF EXISTS "Public Read Kabinet" ON public.himtika_kabinet;
DROP POLICY IF EXISTS "Public Read About" ON public.himtika_about;
DROP POLICY IF EXISTS "Public Read Divisi" ON public.himtika_divisi;
DROP POLICY IF EXISTS "Public Read Pengurus" ON public.himtika_pengurus;

DROP POLICY IF EXISTS "Admin All Access Kabinet" ON public.himtika_kabinet;
DROP POLICY IF EXISTS "Admin All Access About" ON public.himtika_about;
DROP POLICY IF EXISTS "Admin All Access Divisi" ON public.himtika_divisi;
DROP POLICY IF EXISTS "Admin All Access Pengurus" ON public.himtika_pengurus;

CREATE POLICY "Public Read Kabinet" ON public.himtika_kabinet FOR SELECT USING (true);
CREATE POLICY "Public Read About" ON public.himtika_about FOR SELECT USING (true);
CREATE POLICY "Public Read Divisi" ON public.himtika_divisi FOR SELECT USING (true);
CREATE POLICY "Public Read Pengurus" ON public.himtika_pengurus FOR SELECT USING (true);

CREATE POLICY "Admin All Access Kabinet" ON public.himtika_kabinet FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admin All Access About" ON public.himtika_about FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admin All Access Divisi" ON public.himtika_divisi FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admin All Access Pengurus" ON public.himtika_pengurus FOR ALL USING (auth.role() = 'authenticated');

-- Insert default data hanya jika tabel masih kosong (cegah duplikasi)
INSERT INTO public.himtika_kabinet (nama_kabinet, tagline, deskripsi, periode, is_active)
SELECT 
    'SINERGIS',
    'Sinergi, Inovatif, Eksplorasi, Responsif, Generalis, Sistematis',
    'Kabinet SINERGIS HIMTIKA periode 2024/2025 berfokus pada kolaborasi dan inovasi teknologi.',
    '2024/2025',
    true
WHERE NOT EXISTS (SELECT 1 FROM public.himtika_kabinet);

INSERT INTO public.himtika_about (visi, misi, sejarah_text)
SELECT 
    'Mewujudkan HIMTIKA sebagai wadah pengembangan potensi mahasiswa Informatika UNSIKA yang berintegritas, inovatif, dan berdaya saing.',
    '["Menyelenggarakan kegiatan akademik dan non-akademik yang berkualitas", "Membangun hubungan internal dan eksternal yang sinergis", "Mengembangkan inovasi riset dan teknologi di lingkungan kampus"]'::jsonb,
    'HIMTIKA (Himpunan Mahasiswa Teknik Informatika) didirikan di Universitas Singaperbangsa Karawang sebagai wadah pemersatu dan aspirasi seluruh mahasiswa Informatika.'
WHERE NOT EXISTS (SELECT 1 FROM public.himtika_about);

-- Seed 6 Divisi Resmi
INSERT INTO public.himtika_divisi (nama_divisi, urutan)
SELECT name, urutan FROM (VALUES
  ('Steering Committee', 0),
  ('Divisi Internal', 1),
  ('Divisi RnD', 2),
  ('Divisi Relasi', 3),
  ('Divisi Edukasi', 4),
  ('Divisi Infokom', 5)
) AS t(name, urutan)
WHERE NOT EXISTS (SELECT 1 FROM public.himtika_divisi);

-- ==================== STORAGE BUCKET ====================
INSERT INTO storage.buckets (id, name, public)
VALUES ('himtika-assets', 'himtika-assets', true)
ON CONFLICT (id) DO UPDATE SET public = true;

DROP POLICY IF EXISTS "Public Read Himtika Assets" ON storage.objects;
DROP POLICY IF EXISTS "Admin Upload Himtika Assets" ON storage.objects;
DROP POLICY IF EXISTS "Admin Update Himtika Assets" ON storage.objects;
DROP POLICY IF EXISTS "Admin Delete Himtika Assets" ON storage.objects;

CREATE POLICY "Public Read Himtika Assets" ON storage.objects 
FOR SELECT USING (bucket_id = 'himtika-assets');

CREATE POLICY "Admin Upload Himtika Assets" ON storage.objects 
FOR INSERT WITH CHECK (bucket_id = 'himtika-assets' AND auth.role() = 'authenticated');

CREATE POLICY "Admin Update Himtika Assets" ON storage.objects 
FOR UPDATE USING (bucket_id = 'himtika-assets' AND auth.role() = 'authenticated');

CREATE POLICY "Admin Delete Himtika Assets" ON storage.objects 
FOR DELETE USING (bucket_id = 'himtika-assets' AND auth.role() = 'authenticated');
