export interface Format {
  id: string;
  text: string;
  qualities: Quality[];
}

export interface Quality {
  id: string;
  text: string;
}

export const Formats: Format[] = [
  {
    id: 'any',
    text: 'Tous',
    qualities: [
      { id: 'best', text: 'Meilleur' },
      { id: '2160', text: '2160p' },
      { id: '1440', text: '1440p' },
      { id: '1080', text: '1080p' },
      { id: '720', text: '720p' },
      { id: '480', text: '480p' },
      { id: 'worst', text: 'Pire' },
      { id: 'audio', text: 'Audio uniquement' },
    ],
  },
  {
    id: 'mp4',
    text: 'MP4',
    qualities: [
      { id: 'best', text: 'Meilleur' },
      { id: 'best_ios', text: 'Meilleur (iOS)' },
      { id: '2160', text: '2160p' },
      { id: '1440', text: '1440p' },
      { id: '1080', text: '1080p' },
      { id: '720', text: '720p' },
      { id: '480', text: '480p' },
      { id: 'worst', text: 'Pire' },
    ],
  },
  {
    id: 'm4a',
    text: 'M4A',
    qualities: [
      { id: 'best', text: 'Meilleur' },
      { id: '192', text: '192 kbps' },
      { id: '128', text: '128 kbps' },
    ],
  },
  {
    id: 'mp3',
    text: 'MP3',
    qualities: [
      { id: 'best', text: 'Meilleur' },
      { id: '320', text: '320 kbps' },
      { id: '192', text: '192 kbps' },
      { id: '128', text: '128 kbps' },
    ],
  },
  {
    id: 'opus',
    text: 'OPUS',
    qualities: [{ id: 'best', text: 'Meilleur' }],
  },
  {
    id: 'wav',
    text: 'WAV',
    qualities: [{ id: 'best', text: 'Meilleur' }],
  },
  {
    id: 'flac',
    text: 'FLAC',
    qualities: [{ id: 'best', text: 'Meilleur' }],
  },
  {
    id: 'thumbnail',
    text: 'Thumbnail',
    qualities: [{ id: 'best', text: 'Meilleur' }],
  },
];
