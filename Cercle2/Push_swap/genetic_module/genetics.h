/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   genetics.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: chrleroy <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/03 08:54:41 by chrleroy          #+#    #+#             */
/*   Updated: 2024/10/03 09:01:25 by chrleroy         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GENETICS_H
# define GENETICS_H

typedef	struct g_cell
{
	long	evolution_stage;
	long	fitness;
	long	*instructions;
	struct	*next
	struct	*prev
}	t_cell;

#endif
