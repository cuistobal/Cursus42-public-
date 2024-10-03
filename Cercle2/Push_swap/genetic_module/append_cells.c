/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   append_cells.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: chrleroy <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/03 09:01:55 by chrleroy          #+#    #+#             */
/*   Updated: 2024/10/03 09:11:39 by chrleroy         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "genetics.h"

void	append_evolution_stage()
{
	current->evolution++;
}

void	append_fitness()
{
	current->fitness += get_movements();
}

void	append_instructions()
{
	int		*additional_instructions;
	int		*appended_instructions;
	int		global_index;
	int		additional_index;

	global_index = 0;
	additional_index = 0;
	appended_instructions = (int *)malloc(sizeof(int) * current->fitness);
	while (current->instructions)
	{
		appended_instructions[global_index] = instructions[global_index];
		global_index++;
	}
	additional_instructions = get_additional_instructions();
	while (additional_instructions)
	{
		appended_instructions[global_index] = additional_instructions[additional_index];
		global_index++;
		additional_index++;
	}
}
