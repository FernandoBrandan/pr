// @ts-check
import { defineConfig } from 'astro/config'
import starlight from '@astrojs/starlight'

// https://astro.build/config
export default defineConfig({

	devToolbar: {
		enabled: false
	},
	integrations: [
		starlight({
			title: 'Proyectos',
			customCss: [
				"./src/styles/global.css" // Ruta a tu archivo CSS
			],
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/withastro/starlight' }],
			sidebar: [
				{
					label: 'Projects',
					autogenerate: { directory: '01 - Projects' },
				},
				{
					label: 'Backend',
					autogenerate: { directory: '03 - Backend' },
				},
				{
					label: 'Architectures',
					autogenerate: { directory: '04 - Architectures' },
				},
				{
					label: 'System-design-notes',
					autogenerate: { directory: '05 -System-design-notes' },
				},
				{
					label: 'Fundaments',
					autogenerate: { directory: 'Fundaments' },
				},
				{
					label: 'Extra',
					autogenerate: { directory: 'Extra' },
				},
			],
		}),
	],

})