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
					label: 'Main',
					autogenerate: { directory: 'main' },
				},
				{
					label: 'Projects',
					autogenerate: { directory: 'projects' },
				}
			],
		}),
	],

})
